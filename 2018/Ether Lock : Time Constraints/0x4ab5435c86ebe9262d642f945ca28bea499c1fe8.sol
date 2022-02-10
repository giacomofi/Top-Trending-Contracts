['pragma solidity ^0.4.14;\n', '\n', '/**\n', ' * Contract that exposes the needed erc20 token functions\n', ' */\n', '\n', 'contract ERC20Interface {\n', '  // Send _value amount of tokens to address _to\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  // Get the account balance of another account with address _owner\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '}\n', '\n', '/**\n', ' * Contract that will forward any incoming Ether to its creator\n', ' */\n', 'contract Forwarder {\n', '  // Address to which any funds sent to this contract will be forwarded\n', '  address public parentAddress;\n', '  event ForwarderDeposited(address from, uint value, bytes data);\n', '\n', '  event TokensFlushed(\n', '    address tokenContractAddress, // The contract address of the token\n', '    uint value // Amount of token sent\n', '  );\n', '\n', '  /**\n', '   * Create the contract, and set the destination address to that of the creator\n', '   */\n', '  function Forwarder() {\n', '    parentAddress = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * Modifier that will execute internal code block only if the sender is a parent of the forwarder contract\n', '   */\n', '  modifier onlyParent {\n', '    if (msg.sender != parentAddress) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * Default function; Gets called when Ether is deposited, and forwards it to the destination address\n', '   */\n', '  function() payable {\n', '    if (!parentAddress.call.value(msg.value)(msg.data))\n', '      throw;\n', '    // Fire off the deposited event if we can forward it  \n', '    ForwarderDeposited(msg.sender, msg.value, msg.data);\n', '  }\n', '\n', '  /**\n', '   * Execute a token transfer of the full balance from the forwarder token to the main wallet contract\n', '   * @param tokenContractAddress the address of the erc20 token contract\n', '   */\n', '  function flushTokens(address tokenContractAddress) onlyParent {\n', '    ERC20Interface instance = ERC20Interface(tokenContractAddress);\n', '    var forwarderAddress = address(this);\n', '    var forwarderBalance = instance.balanceOf(forwarderAddress);\n', '    if (forwarderBalance == 0) {\n', '      return;\n', '    }\n', '    if (!instance.transfer(parentAddress, forwarderBalance)) {\n', '      throw;\n', '    }\n', '    TokensFlushed(tokenContractAddress, forwarderBalance);\n', '  }\n', '\n', '  /**\n', '   * It is possible that funds were sent to this address before the contract was deployed.\n', '   * We can flush those funds to the destination address.\n', '   */\n', '  function flush() {\n', '    if (!parentAddress.call.value(this.balance)())\n', '      throw;\n', '  }\n', '}']