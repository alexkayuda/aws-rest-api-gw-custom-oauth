package main

import (
	"context"
	"log"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context, request events.APIGatewayCustomAuthorizerRequest) (events.APIGatewayCustomAuthorizerResponse, error) {

	// basically, if there is a Header AuthorizationToken
	// and if it starts with "Bearer <anything>" 
	// we should be good!

	tokenString := extractBearerToken(request.AuthorizationToken)
	if tokenString == "" {
		log.Println("No Token Provided")
		return generatePolicy("", "Deny", request.MethodArn), nil
	}

	return generatePolicy("principal_id", "Allow", request.MethodArn), nil
}

func extractBearerToken(authHeader string) string {
	parts := strings.Split(authHeader, " ")
	if len(parts) == 2 && strings.EqualFold(parts[0], "Bearer") {
		return parts[1]
	} else {
		return ""
	}
}

func generatePolicy(principalId, effect, resource string) events.APIGatewayCustomAuthorizerResponse {

	return events.APIGatewayCustomAuthorizerResponse{
		PrincipalID: principalId,
		PolicyDocument: events.APIGatewayCustomAuthorizerPolicy{
			Version: "2012-10-17",
			Statement: []events.IAMPolicyStatement{
				{
					Action:   []string{"execute-api:Invoke"},
					Effect:   effect,
					Resource: []string{resource},
				},
			},
		},
	}
}

func main() {
	lambda.Start(handler)
}
