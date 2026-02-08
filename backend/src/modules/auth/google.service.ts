import { OAuth2Client } from "google-auth-library";
import { env } from "../../config/env";

const client = new OAuth2Client(env.GOOGLE_CLIENT_ID);

export async function verifyGoogleToken(idToken: string) {
  const ticket = await client.verifyIdToken({
    idToken,
    audience: env.GOOGLE_CLIENT_ID,
  });

  const payload = ticket.getPayload();

  if (!payload || !payload.email) {
    throw new Error("INVALID_GOOGLE_TOKEN");
  }

  return {
    email: payload.email,
    name: payload.name,
    picture: payload.picture,
  };
}
