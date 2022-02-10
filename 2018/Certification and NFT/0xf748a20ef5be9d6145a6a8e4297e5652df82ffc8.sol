['pragma solidity ^0.4.23;\n', '\n', 'contract DelegateProvider {\n', '    function getDelegate() public view returns (address delegate);\n', '}\n', '\n', 'contract DelegateProxy {\n', '  /**\n', '   * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)\n', '   * @param _dst Destination address to perform the delegatecall\n', '   * @param _calldata Calldata for the delegatecall\n', '   */\n', '  function delegatedFwd(address _dst, bytes _calldata) internal {\n', '    assembly {\n', '      let result := delegatecall(sub(gas, 10000), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)\n', '      let size := returndatasize\n', '\n', '      let ptr := mload(0x40)\n', '      returndatacopy(ptr, 0, size)\n', '\n', '      // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.\n', '      // if the call returned error data, forward it\n', '      switch result case 0 { revert(ptr, size) }\n', '      default { return(ptr, size) }\n', '    }\n', '  }\n', '}\n', '\n', 'contract Token {\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '}\n', '\n', 'contract WalletStorage {\n', '    address public owner;\n', '}\n', '\n', 'contract WalletProxy is WalletStorage, DelegateProxy {\n', '    event ReceivedETH(address from, uint256 amount);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function() public payable {\n', '        if (msg.value > 0) {\n', '            emit ReceivedETH(msg.sender, msg.value);\n', '        }\n', '        if (gasleft() > 2400) {\n', '            delegatedFwd(DelegateProvider(owner).getDelegate(), msg.data);\n', '        }\n', '    }\n', '}\n', '\n', 'contract Wallet is WalletStorage {\n', '    function transferERC20Token(Token token, address to, uint256 amount) public returns (bool) {\n', '        require(msg.sender == owner);\n', '        return token.transfer(to, amount);\n', '    }\n', '    \n', '    function transferEther(address to, uint256 amount) public returns (bool) {\n', '        require(msg.sender == owner);\n', '        return to.call.value(amount)();\n', '    }\n', '\n', '    function() public payable {}\n', '}']