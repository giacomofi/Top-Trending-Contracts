['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract Dragon {\n', '    \n', '    function transfer(address receiver, uint amount)returns(bool ok);\n', '    function balanceOf( address _address )returns(uint256);\n', '\n', '    \n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', 'contract DragonLock is Ownable {\n', '    \n', '    using SafeMath for uint;\n', '   \n', '  \n', '    Dragon public tokenreward; \n', '    \n', '    \n', '   \n', '   \n', '    \n', '    uint public TimeLock;\n', '    address public receiver;\n', ' \n', '    \n', '    \n', '  \n', '    \n', '    function DragonLock (){\n', '        \n', '        tokenreward = Dragon (  0x814f67fa286f7572b041d041b1d99b432c9155ee ); // dragon token address\n', '        \n', '        TimeLock = now + 90 days;\n', '       \n', '        receiver = 0x2b29397aEC174A52bff15225efbb5311c7d63b38; // Receiver address change\n', '        \n', '      \n', '        \n', '    }\n', '    \n', '    \n', '    //allows token holders to withdar their dragons after timelock expires\n', '    function withdrawDragons(){\n', '        \n', '        require ( now > TimeLock );\n', '        require ( receiver == msg.sender );\n', '      \n', '       \n', '        tokenreward.transfer ( msg.sender , tokenreward.balanceOf (this)  );\n', '        \n', '    }\n', '    \n', '    \n', '\n', '   \n', '  \n', '\n', '    \n', '   \n', '}']