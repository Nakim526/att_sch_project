export interface AdminTypes {
  id: string;
  email: string;
}

export interface CreateSchoolTypes {
  principalName: string;
  principalEmail: string;
  name: string;
  address: string;
  phone?: string;
  email?: string;
}

export interface UpdateSchoolTypes {
  principalName: string;
  principalEmail: string;
  name: string;
  address: string;
  phone?: string;
  email?: string;
}
