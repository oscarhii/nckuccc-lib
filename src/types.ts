export type Book={id:string;title:string;author?:string;publisher?:string;pages?:number;description?:string;coverUrl?:string;category?:string;featured?:boolean;createdAt:string;available:boolean};
export type Loan={id:string;bookId:string;bookTitle:string;borrowerName:string;dueAt:string;returnedAt?:string};
