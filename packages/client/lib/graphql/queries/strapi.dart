String getBlogs = """
  query Data(\$filters: BlogFiltersInput) {
    blogs(filters: \$filters) {
      data {
        id
        attributes { 
          title
          description
          media {
            data {
              attributes {
                mime
                url
              }
            }
          }
          publishedAt
          types {
            data {
              id
              attributes {
                title
              }
            }
          }
        }
      }
    }
  }
""";

String getBlog = """
  query Data(\$blogId: ID) {
    blog(id: \$blogId) {
      data {
        id
        attributes {
          title
          body
          description
          media {
            data {
              attributes {
                mime
                url
              }
            }
          }
          publishedAt
          types {
            data {
              id
              attributes {
                title
              }
            }
          }
        }
      }
    }
  }
""";

String getBlogTypes = """
  query Data {
    blogTypes {
      data {
        id
        attributes {
          title
        }
      }
    }
  }
""";

String getProgramTags = """
  query Data(\$filters: ProgramTagFiltersInput) {
    programTags(filters: \$filters) {
      data {
        id
        attributes {
          title
        }
      }
    }
  }
""";

String getPrograms = """
  query Data(\$filters: ProgramFiltersInput, \$pagination: PaginationArg) {
    programs(filters: \$filters, pagination: \$pagination) {
      data {
        id
        attributes {
          title
          description
          image {
            data {
              attributes {
                url
                mime
              }
            }
          }
          objective
          level
          publishedAt
          type {
            data {
              attributes {
                title
              }
              id
            }
          }
          materials {
            data {
              id
              attributes {
                title
                image {
                  data {
                    attributes {
                      url
                      mime
                    }
                    id
                  }
                }
              }
              id
            }
          }
          tags {
            data {
              id
              attributes {
                title
              }
            }
          }
        }
      }
    }
  }
""";

String getProgram = """
  query Data(\$programId: ID) {
    program(id: \$programId) {
      data {
        id
        attributes {
          description
          title
          body
          image {
            data {
              attributes {
                url
                mime
              }
            }
          }
          objective
          level
          publishedAt
          type {
            data {
              attributes {
                title
              }
              id
            }
          }
          tags {
            data {
              id
              attributes {
                title
              }
            }
          }
          materials {
            data {
              id
              attributes {
                title
                image {
                  data {
                    attributes {
                      url
                      mime
                    }
                    id
                  }
                }
              }
              id
            }
          }
          sessions {
            data {
              id
              attributes {
                title
                body
                day
                media {
                  data {
                    attributes {
                      mime
                      url
                    }
                    id
                  }
                }
              }
              id
            }
          }
        }
      }
    }
  }
""";

String getSession = """
  query Session(\$sessionId: ID) {
    session(id: \$sessionId) {
      data {
        id
        attributes {
          title
          body
          day
          media {
            data {
              attributes {
                url
                mime
              }
            }
          }
        }
      }
    }
  }
""";

String createProgram = """
  mutation Mutation(\$data: CreateProgramInput!) {
    createProgram(data: \$data) {
      id
      strapiId
      closed
    }
  }
""";

String createSession = """
  mutation CreateSession(\$data: CreateSessionInput!) {
    createSession(data: \$data) {
      strapiId
      programId
    }
  }
""";

String deleteSession = """
  mutation DeleteSession(\$data: DeleteSessionInput!) {
    deleteSession(data: \$data) {
      strapiId
    }
  }
""";

String getCGV = """
  query Query {
    cgv {
      data {
        attributes {
          body
        }
      }
    }
  }
""";

String getLogalNotice = """
  query Query {
    legalNotice {
      data {
        attributes {
          body
        }
      }
    }
  }
""";

String getRecipes = """
  query Data(\$filters: RecipeFiltersInput) {
    recipes(filters: \$filters) {
      data {
        id
        attributes {
          title
          body
          description
          media {
            data {
              id
              attributes {
                mime
                url
              }
            }
          }
          tags {
            data {
              id
              attributes {
                title
              }
            }
          }
        }
      }
    }
  }
""";

String getRecipesTags = """
  query Query {
    recipeTypes {
      data {
        id
        attributes {
          title
        }
      }
    }
  }
""";

String getRecipe = """
  query Recipe(\$recipeId: ID) {
    recipe(id: \$recipeId) {
      data {
        id
        attributes {
          title
          body
          description
          media {
            data {
              id
              attributes {
                url
                mime
              }
            }
          }
          tags {
            data {
              id
              attributes {
                title
              }
            }
          }
        }
      }
    }
  }
""";

String favRecipe = """
  mutation FavRecipe(\$data: FavRecipeInput!) {
    favRecipe(data: \$data) {
      id
      strapiId
    }
  }
""";

String unfavRecipe = """
  mutation UnfavRecipe(\$data: UnfavRecipeInput!) {
    unfavRecipe(data: \$data) {
      strapiId
      userId
    }
  }
""";
