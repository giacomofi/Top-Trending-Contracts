['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * Changes by https://www.docademic.com/\n', ' */\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Destroyable is Ownable{\n', '    /**\n', '     * @notice Allows to destroy the contract and return the tokens to the owner.\n', '     */\n', '    function destroy() public onlyOwner{\n', '        selfdestruct(owner);\n', '    }\n', '}\n', '\n', '\n', 'interface Token {\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '\n', '    function balanceOf(address who) view external returns (uint256);\n', '}\n', '\n', 'contract TokenVault is Ownable, Destroyable {\n', '    using SafeMath for uint256;\n', '\n', '    Token public token;\n', '\n', '    /**\n', '     * @dev Constructor.\n', '     * @param _token The token address\n', '     */\n', '    function TokenVault(address _token) public{\n', '        require(_token != address(0));\n', '        token = Token(_token);\n', '    }\n', '\n', '    /**\n', '     * @dev Get the token balance of the contract.\n', '     * @return _balance The token balance of this contract in wei\n', '     */\n', '    function Balance() view public returns (uint256 _balance) {\n', '        return token.balanceOf(address(this));\n', '    }\n', '\n', '    /**\n', '     * @dev Get the token balance of the contract.\n', '     * @return _balance The token balance of this contract in ether\n', '     */\n', '    function BalanceEth() view public returns (uint256 _balance) {\n', '        return token.balanceOf(address(this)) / 1 ether;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the owner to flush the tokens of the contract.\n', '     */\n', '    function transferTokens(address _to, uint256 amount) public onlyOwner {\n', '        token.transfer(_to, amount);\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the owner to flush the tokens of the contract.\n', '     */\n', '    function flushTokens() public onlyOwner {\n', '        token.transfer(owner, token.balanceOf(address(this)));\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the owner to destroy the contract and return the tokens to the owner.\n', '     */\n', '    function destroy() public onlyOwner {\n', '        token.transfer(owner, token.balanceOf(address(this)));\n', '        selfdestruct(owner);\n', '    }\n', '\n', '}']