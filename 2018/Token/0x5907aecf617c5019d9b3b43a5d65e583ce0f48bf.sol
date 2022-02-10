['pragma solidity ^0.4.23;\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20BasicInterface {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    uint8 public decimals;\n', '}\n', '\n', '\n', 'contract BatchTransferWallet is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '    * @dev Send token to multiple address\n', '    * @param _investors The addresses of EOA that can receive token from this contract.\n', '    * @param _tokenAmounts The values of token are sent from this contract.\n', '    */\n', '    function batchTransferFrom(address _tokenAddress, address[] _investors, uint256[] _tokenAmounts) public {\n', '        ERC20BasicInterface token = ERC20BasicInterface(_tokenAddress);\n', '        require(_investors.length == _tokenAmounts.length && _investors.length != 0);\n', '\n', '        for (uint i = 0; i < _investors.length; i++) {\n', '            require(_tokenAmounts[i] > 0 && _investors[i] != 0x0);\n', '            require(token.transferFrom(msg.sender,_investors[i], _tokenAmounts[i]));\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev return token balance this contract has\n', '    * @return _address token balance this contract has.\n', '    */\n', '    function balanceOfContract(address _tokenAddress,address _address) public view returns (uint) {\n', '        ERC20BasicInterface token = ERC20BasicInterface(_tokenAddress);\n', '        return token.balanceOf(_address);\n', '    }\n', '    function getTotalSendingAmount(uint256[] _amounts) private pure returns (uint totalSendingAmount) {\n', '        for (uint i = 0; i < _amounts.length; i++) {\n', '            require(_amounts[i] > 0);\n', '            totalSendingAmount += _amounts[i];\n', '        }\n', '    }\n', '    // Events allow light clients to react on\n', '    // changes efficiently.\n', '    event Sent(address from, address to, uint amount);\n', '    function transferMulti(address[] receivers, uint256[] amounts) payable {\n', '        require(msg.value != 0 && msg.value >= getTotalSendingAmount(amounts));\n', '        for (uint256 j = 0; j < amounts.length; j++) {\n', '            receivers[j].transfer(amounts[j]);\n', '            emit Sent(msg.sender, receivers[j], amounts[j]);\n', '        }\n', '    }\n', '    /**\n', '        * @dev Withdraw the amount of token that is remaining in this contract.\n', '        * @param _address The address of EOA that can receive token from this contract.\n', '        */\n', '        function withdraw(address _address) public onlyOwner {\n', '            require(_address != address(0));\n', '            _address.transfer(address(this).balance);\n', '        }\n', '}']