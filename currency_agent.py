import argparse
import asyncio
import logging
from uuid import uuid4

import httpx
from a2a.client import A2ACardResolver, A2AClient
from a2a.types import AgentCard, MessageSendParams, SendMessageRequest

PUBLIC_AGENT_CARD_PATH = '/.well-known/agent.json'

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


async def send_message_and_get_response(base_url: str, message: str):
    async with httpx.AsyncClient() as httpx_client:
        # Fetch agent card
        logger.info(f'Fetching agent card from: {base_url}{PUBLIC_AGENT_CARD_PATH}')
        resolver = A2ACardResolver(httpx_client=httpx_client, base_url=base_url)
        agent_card: AgentCard = await resolver.get_agent_card()

        logger.info(f'Agent capabilities: {agent_card.capabilities}')
        logger.info('A2AClient initialized.')

        client = A2AClient(httpx_client=httpx_client, agent_card=agent_card)

        # Create send message request
        send_message_payload = {
            'message': {
                'role': 'user',
                'parts': [{'kind': 'text', 'text': message}],
                'messageId': uuid4().hex,
            }
        }

        request = SendMessageRequest(
            id=str(uuid4()), params=MessageSendParams(**send_message_payload)
        )

        # Send message and await response
        response = await client.send_message(request)
        return response


def main():
    parser = argparse.ArgumentParser(description="Currency Agent CLI")

    parser.add_argument(
        '--question',
        type=str,
        required=True,
        help="Question to ask the currency agent (e.g. '10 USD to INR' or 'What is the weather in London?')"
    )

    parser.add_argument(
        '--base_url',
        type=str,
        default='http://localhost:10000',
        help="Base URL of the agent service"
    )

    args = parser.parse_args()

    result = asyncio.run(send_message_and_get_response(args.base_url, args.question))
    print(f"\nAgent Response: {result}")


if __name__ == '__main__':
    main()
