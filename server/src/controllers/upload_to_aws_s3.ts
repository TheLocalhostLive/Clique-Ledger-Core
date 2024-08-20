import { S3Client } from '@aws-sdk/client-s3';
import multerS3 from 'multer-s3';

export function createS3Storage() {
  const accessKeyId = process.env.AWS_IAM_ACCESS_KEY;
  const secretAccessKey = process.env.AWS_IAM_SECRET_KEY;
  if (!accessKeyId || !secretAccessKey) {
    throw new Error('AWS IAM credentials are not defined');
  }

  const credentials = {
    accessKeyId,
    secretAccessKey,
  };

  const s3Config = new S3Client({
    region: 'ap-south-1',
    credentials,
  });

  const storage = multerS3({
    s3: s3Config,
    bucket: 'clique-ledger-s3',
    key: (req, file, cb) => {
      const fileName = Date.now().toString() + file.originalname;
      console.log(fileName);
      cb(null, Date.now().toString() + file.originalname);
    },
  });
  return storage;
}
