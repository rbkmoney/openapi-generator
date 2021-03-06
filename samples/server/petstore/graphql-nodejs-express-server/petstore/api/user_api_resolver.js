/**
 * 
 * OpenAPI Petstore
 * 
 * 
 * This is a sample server Petstore server. For this sample, you can use the api key `special-key` to test the authorization filters.
 * 
 * Version: 1.0.0
 * 
 * Generated by OpenAPI Generator: https://openapi-generator.tech
 */

// package petstore

// user_api

export default {
    Query: {

        // @return User
        GetUserByName: ($username) => {
            return {
                "username": "username_example"
            };
        },

        // @return String!
        LoginUser: ($username, $password) => {
            return {
                "username": "username_example",
                "password": "password_example"
            };
        },

        // @return 
        LogoutUser: () => {
            return {
                
            };
        },

    },

    Mutation: {

        // @return 
        CreateUser: ($body) => {
            return {
                "body": ""
            };
        },

        // @return 
        CreateUsersWithArrayInput: ($body) => {
            return {
                "body": ""
            };
        },

        // @return 
        CreateUsersWithListInput: ($body) => {
            return {
                "body": ""
            };
        },

        // @return 
        DeleteUser: ($username) => {
            return {
                "username": "username_example"
            };
        },

        // @return 
        UpdateUser: ($username, $body) => {
            return {
                "username": "username_example",
                "body": ""
            };
        },

    }
}