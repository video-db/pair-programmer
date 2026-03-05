#!/bin/bash
# Wrapper to launch the MCP server using its own directory path.
# Avoids ${CLAUDE_PLUGIN_ROOT} expansion issues in plugin .mcp.json
exec node "$(dirname "$0")/recorder-mcp.js"
