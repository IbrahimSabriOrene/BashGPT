#!/bin/bash

# Your OpenAI API key
OPENAI_API_KEY="your_api_key_here"

# The model you want to use
MODEL_NAME="gpt-3.5-turbo"

# Function to make the API request
make_api_request() {
  local user_message="$1"
  
  # Make the API request using curl
  API_RESPONSE=$(curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d '{
       "model": "'"${MODEL_NAME}"'",
       "messages": [{"role": "system", "content": "You are a helpful assistant that provides information for linux commands, returning the code only."}, {"role": "user", "content": "'"${user_message}"'"}],
       "temperature": 0.7
     }' "https://api.openai.com/v1/chat/completions")
}

# Get user's question
echo "Ask a question:"
read USER_QUESTION

# Make the API request with the user's question
make_api_request "$USER_QUESTION"

# Check if the request was successful
if [ $? -eq 0 ]; then
  # Check if the response is not null or empty
  if [ -n "$API_RESPONSE" ]; then
    # Extract and print the assistant's response
    ASSISTANT_RESPONSE=$(echo "$API_RESPONSE" | jq -r '.choices[].message.content')
    echo "Assistant's Response:"
    echo "$ASSISTANT_RESPONSE"
  else
    echo "Error: Empty or null API response."
  fi
else
  echo "Failed to retrieve data from the OpenAI API."
fi
