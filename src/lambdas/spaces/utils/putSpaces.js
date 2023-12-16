const { UpdateCommand } = require("@aws-sdk/lib-dynamodb");

async function putSpaces(event, docClient) {
  if (event.pathParameters) {
    if ("id" in event.pathParameters) {
      const spaceId = event.pathParameters.id;
      const command = new UpdateCommand({
        TableName: "Spacefinder",
        Key: {
          id: spaceId,
        },
        UpdateExpression: "set #n = :name, age = :age",
        ExpressionAttributeValues: {
          ":name": `${event.body.name}`,
          ":age": event.body.age,
        },
        ExpressionAttributeNames: {
          "#n": "name",
        },
        ReturnValues: "ALL_NEW",
      });
      const response = await docClient.send(command);
      console.log(`response: ${response}`);
      return {
        statusCode: 200,
        body: JSON.stringify(`updated space with id ${event.pathParameters.id}:
        name=${event.body.name}
        age=${event.body.age}`),
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

module.exports = putSpaces;
