['// File: contracts/CNTMToken/ERC223/ERC223Interface.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'contract ERC223Interface {\n', '    uint public totalSupply;\n', '    function balanceOf(address who) public view returns (uint);\n', '    function transfer(address to, uint value) public;\n', '    function transfer(address to, uint value, bytes memory data) public;\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '// File: contracts/CNTMToken/ERC223/ERC223ReceivingContract.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', 'contract ERC223ReceivingContract {\n', '/**\n', ' * @dev Standard ERC223 function that will handle incoming token transfers.\n', ' *\n', ' * @param _from  Token sender address.\n', ' * @param _value Amount of tokens.\n', ' * @param _data  Transaction metadata.\n', ' */\n', '    function tokenFallback(address _from, uint _value, bytes memory _data) public;\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/CNTMToken/ERC223/ERC223Token.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Reference implementation of the ERC223 standard token.\n', ' */\n', '\n', 'contract ERC223Token is ERC223Interface {\n', '    using SafeMath for uint;\n', '\n', '    mapping(address => uint) public balances;\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      Invokes the `tokenFallback` function if the recipient is a contract.\n', '     *      The token transfer fails if the recipient is a contract\n', '     *      but does not implement the `tokenFallback` function\n', '     *      or the fallback function to receive funds.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function transfer(address _to, uint _value, bytes memory _data) public {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '\n', '        /* solium-disable-next-line */\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      This function works the same with the previous one\n', "     *      but doesn't contain `_data` param.\n", '     *      Added due to backwards compatibility reasons.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     */\n', '    function transfer(address _to, uint _value) public {\n', '        uint codeLength;\n', '        bytes memory empty;\n', '        /* solium-disable-next-line */\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly .\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, empty);\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns balance of the `_owner`.\n', '     *\n', '     * @param _owner   The address whose balance will be returned.\n', '     * @return balance Balance of the `_owner`.\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/CNTMToken/CNTMToken.sol\n', '\n', 'pragma solidity >=0.4.21 <0.6.0;\n', '\n', '\n', '\n', 'contract TESTToken is ERC223Token, Ownable {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    address mpAddress;\n', '\n', '    modifier onlyMP {\n', '        require(msg.sender == mpAddress);\n', '        _;\n', '    }\n', '\n', '    constructor (\n', '        string memory _name,\n', '        string memory _symbol,\n', '        uint8 _decimals\n', '    ) public {\n', '        symbol = _symbol;\n', '        name = _name;\n', '        decimals = _decimals;\n', '        totalSupply = 1000000000 * (10 ** uint256(decimals));\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function setMarketPlaceAddress(\n', '        address _mpaddress\n', '    ) public onlyOwner {\n', '        mpAddress = _mpaddress;\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint _value,\n', '        bytes memory _data\n', '    ) public onlyMP {\n', '        uint codeLength;\n', '\n', '        /* solium-disable-next-line */\n', '        assembly {\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(_from, _value, _data);\n', '        }\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint _value\n', '    ) public onlyMP {\n', '        uint codeLength;\n', '        bytes memory empty;\n', '\n', '        /* solium-disable-next-line */\n', '        assembly {\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength>0) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(_from, _value, empty);\n', '        }\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '}']