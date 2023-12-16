const { PutCommand } = require("@aws-sdk/lib-dynamodb");
const { randomUUID } = require("crypto");

async function postSpaces(event, docClient) {
  if (event.body && event.body.name && event.body.age) {
    const randomId = randomUUID();
    const command = new PutCommand({
      TableName: "Spacefinder",
      Item: {
        id: randomId,
        name: event.body.name,
        age: event.body.age,
      },
    });
    const response = await docClient.send(command);
    console.log(response);
    return {
      statusCode: 201,
      body: JSON.stringify({ id: randomId }),
    };
  } else {
    return {
      statusCode: 400,
      body: JSON.stringify("body must include values for name and age"),
    };
  }
}

module.exports = postSpaces;
