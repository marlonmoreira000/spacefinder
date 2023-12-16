const { DeleteCommand } = require("@aws-sdk/lib-dynamodb");

async function deleteSpaces(event, docClient) {
  if (event.pathParameters) {
    if ("id" in event.pathParameters) {
      const spaceId = event.pathParameters.id;
      console.log(`spaceId: ${spaceId}`);
      const command = new DeleteCommand({
        TableName: "Spacefinder",
        Key: {
          id: spaceId,
        },
      });
      const response = await docClient.send(command);
      console.log(response);
      // TODO: handle case where item does not exist in db
      return {
        statusCode: 200,
        body: JSON.stringify(`deleted item with id ${spaceId}`),
      };
    } else {
      return {
        statusCode: 400,
        body: JSON.stringify("id required"),
      };
    }
  } else {
    return {
      statusCode: 400,
      body: JSON.stringify("no path parameters exist"),
    };
  }
}

module.exports = deleteSpaces;
