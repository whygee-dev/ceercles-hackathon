String whoAmI = """
  query WhoAmI {
    whoAmI {
      id
      fullname
      email
      emailVerified
      profile {
        birthday
        gender
        avatar
      }
    }
  }
""";

String createUser = """
  mutation CreateUser(\$data: CreateUserDto!) {
    createUser(data: \$data) {
      id
      fullname
      email
    }
  }
""";

String resendEmailConfirmation = """
  mutation Mutation {
    resendEmailConfirmation
  }
""";

String verifyEmail = """
  mutation VerifyEmail(\$token: String!) {
    verifyEmail(token: \$token)
  }
""";

String generatePasswordReset = """
  mutation Mutation(\$email: String!) {
    generatePasswordReset(email: \$email)
  }
""";

String resetPassword = """
  mutation ResetPassword(\$data: ResetPasswordDto!) {
    resetPassword(data: \$data)
  }
""";

String updateUser = """
  mutation UpdateUser(\$data: UpdateUserDto!) {
    updateUser(data: \$data) {
      id
    }
  }
""";

String updateUserProfile = """
  mutation UpdateUserProfile(\$data: UpdateUserProfileInput!) {
    updateUserProfile(data: \$data) {
      userId
    }
  }
""";
