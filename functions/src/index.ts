import { initializeApp } from 'firebase-admin/app';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';

// Initialize the Admin SDK
initializeApp();

const db = getFirestore();

/**
 * Triggered when a new comment is created.
 */
export const oncommentcreated = onDocumentCreated('comments/{commentId}', async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const comment = snapshot.data();
    if (!comment) return;

    const postDoc = await db.collection('posts').doc(comment.postId).get();
    const post = postDoc.data();
    if (!post) return;

    // Skip if commenting on own post
    if (post.uid === comment.uid) return;

    await createNotification(
        post.uid,
        comment.uid,
        comment.authorName,
        comment.authorPhotoUrl,
        'commented on your post',
        'comment',
        comment.postId,
        event.params.commentId
    );

    await scanForMentions(
        comment.content,
        comment.uid,
        comment.authorName,
        comment.authorPhotoUrl,
        comment.postId,
        event.params.commentId
    );
});

/**
 * Triggered when a new reply is created.
 */
export const onreplycreated = onDocumentCreated('replies/{replyId}', async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const reply = snapshot.data();
    if (!reply) return;

    const commentDoc = await db.collection('comments').doc(reply.commentId).get();
    const comment = commentDoc.data();
    if (!comment) return;

    // Skip if replying to own comment
    if (comment.uid === reply.uid) return;

    await createNotification(
        comment.uid,
        reply.uid,
        reply.authorName,
        reply.authorPhotoUrl,
        'replied to your comment',
        'reply',
        reply.postId,
        reply.commentId
    );

    await scanForMentions(
        reply.content,
        reply.uid,
        reply.authorName,
        reply.authorPhotoUrl,
        reply.postId,
        reply.commentId
    );
});

/**
 * Triggered when a new post is created.
 */
export const onpostcreated = onDocumentCreated('posts/{postId}', async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const post = snapshot.data();
    if (!post) return;

    await scanForMentions(post.content, post.uid, post.authorName, post.authorPhotoUrl, event.params.postId);
});

/**
 * Internal helper to create in-app notifications and send push notifications.
 */
async function createNotification(
    receiverId: string,
    senderId: string,
    senderName: string,
    senderPhotoUrl: string | null,
    content: string,
    type: string,
    postId?: string,
    commentId?: string
) {
    const notificationId = db.collection('notifications').doc().id;
    const notification = {
        id: notificationId,
        receiverId,
        senderId,
        senderName,
        senderPhotoUrl,
        content,
        type,
        postId: postId || null,
        commentId: commentId || null,
        isRead: false,
        createdAt: FieldValue.serverTimestamp(),
    };

    await db.collection('notifications').doc(notificationId).set(notification);

    // Fetch device tokens for push notification
    const deviceDoc = await db.collection('devices').doc(receiverId).get();
    const tokens = deviceDoc.data()?.tokens as string[] | undefined;

    if (tokens && tokens.length > 0) {
        const message = {
            notification: {
                title: 'NOWNOWWW',
                body: `${senderName} ${content}`,
            },
            data: {
                postId: postId || '',
                type: type,
            },
            tokens: tokens,
        };
        await getMessaging().sendEachForMulticast(message);
    }
}

/**
 * Scans text for @username patterns.
 */
async function scanForMentions(
    text: string,
    senderId: string,
    senderName: string,
    senderPhotoUrl: string | null,
    postId: string,
    commentId?: string
) {
    const mentionRegex = /@([a-zA-Z0-9_]+)/g;
    let match;
    const usernames = new Set<string>();

    while ((match = mentionRegex.exec(text)) !== null) {
        usernames.add(match[1]);
    }

    for (const username of usernames) {
        const userQuery = await db.collection('users').where('username', '==', username).limit(1).get();
        if (!userQuery.empty) {
            const receiverId = userQuery.docs[0].id;
            if (receiverId !== senderId) {
                await createNotification(
                    receiverId,
                    senderId,
                    senderName,
                    senderPhotoUrl,
                    'mentioned you',
                    'mention',
                    postId,
                    commentId
                );
            }
        }
    }
}
