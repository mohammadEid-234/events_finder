import jwt from 'jsonwebtoken';
import type { Algorithm, Secret, SignOptions } from "jsonwebtoken";
// 1) Read and validate env
const SECRET = process.env.JWT_SECRET;
if (!SECRET) {
    throw new Error('Missing JWT_SECRET environment variable');
}
const JWT_SECRET: Secret = SECRET; // assert to Secret after the check


const ALG: Algorithm = (process.env.JWT_ALG as Algorithm) ?? 'HS256';
const expiresIn = process.env.JWT_ACCESS_TTL as SignOptions["expiresIn"] ?? "15m";

const accessTokenOptions: SignOptions = {
    algorithm: ALG,
    expiresIn,
    issuer: 'events-finder-backend',
    audience: 'events-finder-client',
};
const refreshTokenOptions: SignOptions = {
    ...accessTokenOptions,
    expiresIn: process.env.JWT_REFRESH_TTL as SignOptions["expiresIn"] ?? "7d"
};

export function signAccessToken(payload): string {
    return jwt.sign(payload, JWT_SECRET, accessTokenOptions);
}
export function signRefreshToken(payload): string {
    return jwt.sign(payload, JWT_SECRET, refreshTokenOptions);
}
export function verifyToken(token) {
    return jwt.verify(token, SECRET);
}
