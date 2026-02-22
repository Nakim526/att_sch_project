export interface CreateSchoolTypes {
  userName: string;
  userEmail: string;
  name: string;
  address: string;
  phone?: string;
  email?: string;
}

export interface UpdateSchoolTypes {
  name: string;
  address: string;
  phone?: string;
  email?: string;
}
