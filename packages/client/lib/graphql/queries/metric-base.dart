String deleteBaseMetric =
    """
  mutation DeleteBaseMetric(\$data: DeleteBaseMetricInput!) {
    deleteBaseMetric(data: \$data) {
      id
      name
      createdAt
    }
  }
""";

String createBaseMetric =
    """
  mutation Mutation(\$data: CreateBaseMetricInput!) {
    createBaseMetric(data: \$data) {
      id
      name
    }
  }
""";

String updateBaseMetric =
    """
  mutation UpdateBaseMetric(\$data: UpdateBaseMetricInput!) {
    updateBaseMetric(data: \$data) {
      id
      name
      createdAt
      unit
    }
  }
""";
