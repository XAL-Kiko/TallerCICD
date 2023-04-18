export const getUrlsVOD = /* GraphQL */ `
  query GetUrlsVOD($organizationId: String!) {
    getUrlsVOD(organizationId: $organizationId) {
      filename
      org
      title
      thumbnail
      url
      visible
    }
  }
`;