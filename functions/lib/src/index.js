"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.onPostCreated = exports.onReplyCreated = exports.onCommentCreated = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
admin.initializeApp();
const db = admin.firestore();
exports.onCommentCreated = functions.firestore
    .document('comments/{commentId}')
    .onCreate(async (snapshot, context) => {
    const comment = snapshot.data();
    if (!comment)
        return;
    const postDoc = await db.collection('posts').doc(comment.postId).get();
    const post = postDoc.data();
    if (!post)
        return;
    if (post.uid === comment.uid)
        return;
    await createNotification(post.uid, comment.uid, comment.authorName, comment.authorPhotoUrl, 'commented on your post', 'comment', comment.postId, context.params.commentId);
    await scanForMentions(comment.content, comment.uid, comment.authorName, comment.authorPhotoUrl, comment.postId, context.params.commentId);
});
exports.onReplyCreated = functions.firestore
    .document('replies/{replyId}')
    .onCreate(async (snapshot, context) => {
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
exports.onPostCreated = functions.firestore
    .document('posts/{postId}')
    .onCreate(async (snapshot, context) => {
    const post = snapshot.data();
    if (!post)
        return;
    await scanForMentions(post.content, post.uid, post.authorName, post.authorPhotoUrl, context.params.postId);
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
        postId,
        commentId,
        isRead: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    await db.collection('notifications').doc(notificationId).set(notification);
    const deviceDoc = await db.collection('devices').doc(receiverId).get();
    const tokens = deviceDoc.data()?.tokens;
    if (tokens && tokens.length > 0) {
        const payload = {
            notification: {
                title: 'NOWNOWWW',
                body: `${senderName} ${content}`,
            },
            data: {
                postId: postId || '',
                type: type,
            }
        };
        await admin.messaging().sendToDevice(tokens, payload);
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
                await createNotification(receiverId, senderId, senderName, senderPhotoUrl, 'mentioned you in a post', 'mention', postId, commentId);
            }
        }
    }
}
//# sourceMappingURL=index.js.map