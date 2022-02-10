['pragma solidity 0.6.12;\n', '\n', '// SPDX-License-Identifier: BSD-3-Clause\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address payable public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address payable newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'interface Token {\n', '    function transfer(address to, uint amount) external returns (bool);\n', '    function transferFrom(address _from, address _to, uint _amount) external returns (bool);\n', '}\n', '\n', 'interface USDT {\n', '    function transfer(address to, uint amount) external;\n', '    function transferFrom(address _from, address _to, uint _amount) external;\n', '}\n', '\n', 'contract QuickToEthSwap is Ownable {\n', '    using SafeMath for uint;\n', '    \n', '    event EtherDeposited(uint);\n', '    \n', '    address public tokenAddress = 0xAa589961B9e6a05577fB1Ac6bBd592CF48D689F4;\n', '    \n', '    uint public tokenDecimals = 18;\n', '    \n', '    uint public weiPerToken = 2e18;\n', '    \n', '    function setTokenAddress(address _tokenAddress) public onlyOwner {\n', '        tokenAddress = _tokenAddress;\n', '    }\n', '    \n', '    function setTokenDecimals(uint _tokenDecimals) public onlyOwner {\n', '        tokenDecimals = _tokenDecimals;\n', '    }\n', '    \n', '    function setWeiPerToken(uint _weiPerToken) public onlyOwner {\n', '        weiPerToken = _weiPerToken;\n', '    }\n', '    \n', '    function swap(uint _amount) public {\n', '        require(_amount <= 5 * 10**tokenDecimals, "Cannot swap more than 5 tokens!");\n', '        uint weiAmount = _amount.mul(weiPerToken).div(10**tokenDecimals);\n', '        require(weiAmount > 0, "Invalid ETH amount to transfer");\n', '        require(Token(tokenAddress).transferFrom(msg.sender, owner, _amount), "Cannot transfer tokens");\n', '        msg.sender.transfer(weiAmount);\n', '    }\n', '    \n', '    receive () external payable {\n', '        emit EtherDeposited(msg.value);\n', '    }\n', '    \n', '    function transferAnyERC20Token(address _token, address _to, uint _amount) public onlyOwner {\n', '        Token(_token).transfer(_to, _amount);\n', '    }\n', '    function transferUSDT(address _usdtAddr, address to, uint amount) public onlyOwner {\n', '        USDT(_usdtAddr).transfer(to, amount);\n', '    }\n', '}']