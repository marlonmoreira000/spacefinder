const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient } = require("@aws-sdk/lib-dynamodb");
const getSpaces = require("./utils/getSpaces");
const postSpaces = require("./utils/postSpaces");
const deleteSpaces = require("./utils/deleteSpaces");
const putSpaces = require("./utils/putSpaces");

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

exports.handler = async function (event, context) {
  const httpMethod = event.httpMethod;

  try {
    switch (httpMethod) {
      // GET
      case "GET":
        const getResponse = await getSpaces(event, docClient);
        return getResponse;

      // POST
      case "POST":
        const postResponse = await postSpaces(event, docClient);
        return postResponse;

      // UPDATE
      case "PUT":
        const putResponse = await putSpaces(event, docClient)
        return putResponse;

      // DELETE
      case "DELETE":
        const deleteResponse = await deleteSpaces(event, docClient);
        return deleteResponse;
    }
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify(error.message),
    };
  }
};
