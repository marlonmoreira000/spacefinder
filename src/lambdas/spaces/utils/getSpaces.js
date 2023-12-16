const { GetCommand } = require("@aws-sdk/lib-dynamodb");

async function getSpaces(event, docClient) {
  if (event.pathParameters) {
    if ("id" in event.pathParameters) {
      const spaceId = event.pathParameters.id
      const command = new GetCommand({
        TableName: "Spacefinder",
        Key: {
          id: spaceId,
        },
      });
      const response = await docClient.send(command);
      if (response.Item) {
        return {
          statusCode: 200,
          body: JSON.stringify(response.Item),
        };
      } else {
        return {
          statusCode: 400,
          body: JSON.stringify(`no item found for id ${spaceId}`),
        };
      }
    } else {
      return {
        statusCode: 400,
        body: JSON.stringify("id required")
      }
    }
  } else {
    return {
      statusCode: 400,
      body: JSON.stringify("no path parameters exist"),
    };
  }
}

module.exports = getSpaces;
