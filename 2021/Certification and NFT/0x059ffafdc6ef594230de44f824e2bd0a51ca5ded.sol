['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-24\n', '*/\n', '\n', 'pragma solidity 0.7.5;\n', '\n', '/*\n', '    The MIT License (MIT)\n', '    Copyright (c) 2018 Murray Software, LLC.\n', '    Permission is hereby granted, free of charge, to any person obtaining\n', '    a copy of this software and associated documentation files (the\n', '    "Software"), to deal in the Software without restriction, including\n', '    without limitation the rights to use, copy, modify, merge, publish,\n', '    distribute, sublicense, and/or sell copies of the Software, and to\n', '    permit persons to whom the Software is furnished to do so, subject to\n', '    the following conditions:\n', '    The above copyright notice and this permission notice shall be included\n', '    in all copies or substantial portions of the Software.\n', '    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n', '    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n', '    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n', '    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n', '    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n', '    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n', '    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n', '*/\n', '//solhint-disable max-line-length\n', '//solhint-disable no-inline-assembly\n', '\n', 'contract CloneFactory {\n', '  function createClone(address target, bytes32 salt)\n', '    internal\n', '    returns (address payable result)\n', '  {\n', '    bytes20 targetBytes = bytes20(target);\n', '    assembly {\n', '      // load the next free memory slot as a place to store the clone contract data\n', '      let clone := mload(0x40)\n', '\n', '      // The bytecode block below is responsible for contract initialization\n', '      // during deployment, it is worth noting the proxied contract constructor will not be called during\n', '      // the cloning procedure and that is why an initialization function needs to be called after the\n', '      // clone is created\n', '      mstore(\n', '        clone,\n', '        0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000\n', '      )\n', '\n', '      // This stores the address location of the implementation contract\n', '      // so that the proxy knows where to delegate call logic to\n', '      mstore(add(clone, 0x14), targetBytes)\n', '\n', '      // The bytecode block is the actual code that is deployed for each clone created.\n', '      // It forwards all calls to the already deployed implementation via a delegatecall\n', '      mstore(\n', '        add(clone, 0x28),\n', '        0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000\n', '      )\n', '\n', '      // deploy the contract using the CREATE2 opcode\n', '      // this deploys the minimal proxy defined above, which will proxy all\n', '      // calls to use the logic defined in the implementation contract `target`\n', '      result := create2(0, clone, 0x37, salt)\n', '    }\n', '  }\n', '\n', '  function isClone(address target, address query)\n', '    internal\n', '    view\n', '    returns (bool result)\n', '  {\n', '    bytes20 targetBytes = bytes20(target);\n', '    assembly {\n', '      // load the next free memory slot as a place to store the comparison clone\n', '      let clone := mload(0x40)\n', '\n', '      // The next three lines store the expected bytecode for a miniml proxy\n', '      // that targets `target` as its implementation contract\n', '      mstore(\n', '        clone,\n', '        0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000\n', '      )\n', '      mstore(add(clone, 0xa), targetBytes)\n', '      mstore(\n', '        add(clone, 0x1e),\n', '        0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000\n', '      )\n', '\n', '      // the next two lines store the bytecode of the contract that we are checking in memory\n', '      let other := add(clone, 0x40)\n', '      extcodecopy(query, other, 0, 0x2d)\n', '\n', '      // Check if the expected bytecode equals the actual bytecode and return the result\n', '      result := and(\n', '        eq(mload(clone), mload(other)),\n', '        eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))\n', '      )\n', '    }\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * Contract that exposes the needed erc20 token functions\n', ' */\n', '\n', 'abstract contract ERC20Interface {\n', '  // Send _value amount of tokens to address _to\n', '  function transfer(address _to, uint256 _value)\n', '    public\n', '    virtual\n', '    returns (bool success);\n', '\n', '  // Get the account balance of another account with address _owner\n', '  function balanceOf(address _owner)\n', '    public\n', '    virtual\n', '    view\n', '    returns (uint256 balance);\n', '}\n', '\n', '// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library TransferHelper {\n', '    function safeApprove(\n', '        address token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', "            'TransferHelper::safeApprove: approve failed'\n", '        );\n', '    }\n', '\n', '    function safeTransfer(\n', '        address token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', "            'TransferHelper::safeTransfer: transfer failed'\n", '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        address token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', "            'TransferHelper::transferFrom: transferFrom failed'\n", '        );\n', '    }\n', '\n', '    function safeTransferETH(address to, uint256 value) internal {\n', '        (bool success, ) = to.call{value: value}(new bytes(0));\n', "        require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');\n", '    }\n', '}\n', '\n', '\n', '/**\n', ' * Contract that will forward any incoming Ether to the creator of the contract\n', ' *\n', ' */\n', 'contract Forwarder {\n', '  // Address to which any funds sent to this contract will be forwarded\n', '  address public parentAddress;\n', '  event ForwarderDeposited(address from, uint256 value, bytes data);\n', '\n', '  /**\n', '   * Initialize the contract, and sets the destination address to that of the creator\n', '   */\n', '  function init(address _parentAddress) external onlyUninitialized {\n', '    parentAddress = _parentAddress;\n', '    uint256 value = address(this).balance;\n', '\n', '    if (value == 0) {\n', '      return;\n', '    }\n', '\n', "    (bool success, ) = parentAddress.call{ value: value }('');\n", "    require(success, 'Flush failed');\n", '    // NOTE: since we are forwarding on initialization,\n', "    // we don't have the context of the original sender.\n", '    // We still emit an event about the forwarding but set\n', '    // the sender to the forwarder itself\n', '    emit ForwarderDeposited(address(this), value, msg.data);\n', '  }\n', '\n', '  /**\n', '   * Modifier that will execute internal code block only if the sender is the parent address\n', '   */\n', '  modifier onlyParent {\n', "    require(msg.sender == parentAddress, 'Only Parent');\n", '    _;\n', '  }\n', '\n', '  /**\n', '   * Modifier that will execute internal code block only if the contract has not been initialized yet\n', '   */\n', '  modifier onlyUninitialized {\n', "    require(parentAddress == address(0x0), 'Already initialized');\n", '    _;\n', '  }\n', '\n', '  /**\n', '   * Default function; Gets called when data is sent but does not match any other function\n', '   */\n', '  fallback() external payable {\n', '    flush();\n', '  }\n', '\n', '  /**\n', '   * Default function; Gets called when Ether is deposited with no data, and forwards it to the parent address\n', '   */\n', '  receive() external payable {\n', '    flush();\n', '  }\n', '\n', '  /**\n', '   * Execute a token transfer of the full balance from the forwarder token to the parent address\n', '   * @param tokenContractAddress the address of the erc20 token contract\n', '   */\n', '  function flushTokens(address tokenContractAddress) external onlyParent {\n', '    ERC20Interface instance = ERC20Interface(tokenContractAddress);\n', '    address forwarderAddress = address(this);\n', '    uint256 forwarderBalance = instance.balanceOf(forwarderAddress);\n', '    if (forwarderBalance == 0) {\n', '      return;\n', '    }\n', '\n', '    TransferHelper.safeTransfer(\n', '      tokenContractAddress,\n', '      parentAddress,\n', '      forwarderBalance\n', '    );\n', '  }\n', '\n', '  /**\n', '   * Flush the entire balance of the contract to the parent address.\n', '   */\n', '  function flush() public {\n', '    uint256 value = address(this).balance;\n', '\n', '    if (value == 0) {\n', '      return;\n', '    }\n', '\n', "    (bool success, ) = parentAddress.call{ value: value }('');\n", "    require(success, 'Flush failed');\n", '    emit ForwarderDeposited(msg.sender, value, msg.data);\n', '  }\n', '}\n', '\n', 'contract ForwarderFactory is CloneFactory {\n', '  address public implementationAddress;\n', '\n', '  event ForwarderCreated(address newForwarderAddress, address parentAddress);\n', '\n', '  constructor(address _implementationAddress) {\n', '    implementationAddress = _implementationAddress;\n', '  }\n', '\n', '  function createForwarder(address parent, bytes32 salt) external {\n', '    // include the signers in the salt so any contract deployed to a given address must have the same signers\n', '    bytes32 finalSalt = keccak256(abi.encodePacked(parent, salt));\n', '\n', '    address payable clone = createClone(implementationAddress, finalSalt);\n', '    Forwarder(clone).init(parent);\n', '    emit ForwarderCreated(clone, parent);\n', '  }\n', '}']