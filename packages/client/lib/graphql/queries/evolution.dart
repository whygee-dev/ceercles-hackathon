String createEvolution =
    """
  mutation CreateEvolution(\$data: CreateEvolutionInput!) {
    createEvolution(data: \$data) {
      id
      metrics {
        baseId
        value
      }
      profileId
    }
  }
""";
