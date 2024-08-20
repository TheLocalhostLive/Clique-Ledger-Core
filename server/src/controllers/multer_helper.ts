import multer from 'multer';
import {createS3Storage} from './upload_to_aws_s3';


export function uploadSingleFileHelper(fileFieldName: string) { 
    const uploadSingleFile = multer({storage: createS3Storage()});

    return uploadSingleFile.single(fileFieldName);


}