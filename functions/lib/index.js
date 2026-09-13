"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.onpostcreated = exports.onreplycreated = exports.oncommentcreated = void 0;
const app_1 = require("firebase-admin/app");
const firestore_1 = require("firebase-admin/firestore");
const messaging_1 = require("firebase-admin/messaging");
const firestore_2 = require("firebase-functions/v2/firestore");
(0, app_1.initializeApp)();
const db = (0, firestore_1.getFirestore)();
exports.oncommentcreated = (0, firestore_2.onDocumentCreated)('comments/{commentId}', async (event) => {
    const snapshot = event.data;
    if (!snapshot)
        return;
    const comment = snapshot.data();
    if (!comment)
        return;
    const postDoc = await db.collection('posts').doc(comment.postId).get();
    const post = postDoc.data();
    if (!post)
        return;
    if (post.uid === comment.uid)
        return;
    await createNotification(post.uid, comment.uid, comment.authorName, comment.authorPhotoUrl, 'commented on your post', 'comment', comment.postId, event.params.commentId);
    await scanForMentions(comment.content, comment.uid, comment.authorName, comment.authorPhotoUrl, comment.postId, event.params.commentId);
});
exports.onreplycreated = (0, firestore_2.onDocumentCreated)('replies/{replyId}', async (event) => {
    const snapshot = event.data;
    if (!snapshot)
        return;
    const reply = snapshot.data();
    if (!reply)
        return;
    const commentDoc = await db.collection('comments').doc(reply.commentId).get();
    const comment = commentDoc.data();
    if (!comment)
        return;
    if (comment.uid === reply.uid)
        return;
    await createNotification(comment.uid, reply.uid, reply.authorName, reply.authorPhotoUrl, 'replied to your comment', 'reply', reply.postId, reply.commentId);
    await scanForMentions(reply.content, reply.uid, reply.authorName, reply.authorPhotoUrl, reply.postId, reply.commentId);
});
exports.onpostcreated = (0, firestore_2.onDocumentCreated)('posts/{postId}', async (event) => {
    const snapshot = event.data;
    if (!snapshot)
        return;
    const post = snapshot.data();
    if (!post)
        return;
    await scanForMentions(post.content, post.uid, post.authorName, post.authorPhotoUrl, event.params.postId);
});
async function createNotification(receiverId, senderId, senderName, senderPhotoUrl, content, type, postId, commentId) {
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
        createdAt: firestore_1.FieldValue.serverTimestamp(),
    };
    await db.collection('notifications').doc(notificationId).set(notification);
    const deviceDoc = await db.collection('devices').doc(receiverId).get();
    const tokens = deviceDoc.data()?.tokens;
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
        await (0, messaging_1.getMessaging)().sendEachForMulticast(message);
    }
}
async function scanForMentions(text, senderId, senderName, senderPhotoUrl, postId, commentId) {
    const mentionRegex = /@([a-zA-Z0-9_]+)/g;
    let match;
    const usernames = new Set();
    while ((match = mentionRegex.exec(text)) !== null) {
        usernames.add(match[1]);
    }
    for (const username of usernames) {
        const userQuery = await db.collection('users').where('username', '==', username).limit(1).get();
        if (!userQuery.empty) {
            const receiverId = userQuery.docs[0].id;
            if (receiverId !== senderId) {
                await createNotification(receiverId, senderId, senderName, senderPhotoUrl, 'mentioned you', 'mention', postId, commentId);
            }
        }
    }
}
//# sourceMappingURL=index.js.map