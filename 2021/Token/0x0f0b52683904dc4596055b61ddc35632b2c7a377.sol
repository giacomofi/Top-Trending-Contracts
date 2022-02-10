['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-30\n', '*/\n', '\n', 'pragma solidity >=0.4.22 <0.7.0;\n', '\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnerLog(address indexed previousOwner, address indexed newOwner, bytes4 sig);\n', '\n', '    constructor() public { \n', '        owner = msg.sender; \n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner  public {\n', '        require(newOwner != address(0));\n', '        emit OwnerLog(owner, newOwner, msg.sig);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract ERCPaused is Ownable, Context {\n', '\n', '    bool public pauesed = false;\n', '\n', '    modifier isNotPaued {\n', '        require (!pauesed);\n', '        _;\n', '    }\n', '    function stop() onlyOwner public {\n', '        pauesed = true;\n', '    }\n', '    function start() onlyOwner public {\n', '        pauesed = false;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'library SafeMath {\n', '    \n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) internal balances;\n', '    uint256 internal totalSupply_;\n', '\n', '    /**\n', '     * @dev Total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '     * @dev transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '    */\n', '    function _transfer(address _sender, address _to, uint256 _value) internal returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[_sender] = balances[_sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_sender, _to, _value);\n', '    \n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    mapping(address => uint256) blackList;\n', '\t\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool) {\n', '\t\trequire(blackList[msg.sender] <= 0);\n', '\t\treturn _transfer(msg.sender, _to, _value);\n', '\t}\n', ' \n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '    */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract PausableToken is StandardToken, ERCPaused {\n', '\n', '    function transfer(address _to, uint256 _value) public isNotPaued returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public isNotPaued returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public isNotPaued returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public isNotPaued returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public isNotPaued returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', 'contract BChia is PausableToken {\n', '    string public constant name = "BChia";\n', '    string public constant symbol = "BHA";\n', '    uint public constant decimals = 18;\n', '    using SafeMath for uint256;\n', '\n', '    event Burn(address indexed from, uint256 value);  \n', '    event BurnFrom(address indexed from, uint256 value);  \n', '\n', '    constructor (uint256 _totsupply) public {\n', '\t\ttotalSupply_ = _totsupply.mul(1e18);\n', '        balances[msg.sender] = totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) isNotPaued public returns (bool) {\n', '        if(isBlackList(_to) == true || isBlackList(msg.sender) == true) {\n', '            revert();\n', '        } else {\n', '            return super.transfer(_to, _value);\n', '        }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) isNotPaued public returns (bool) {\n', '        if(isBlackList(_to) == true || isBlackList(msg.sender) == true) {\n', '            revert();\n', '        } else {\n', '            return super.transferFrom(_from, _to, _value);\n', '        }\n', '    }\n', '    \n', '    function burn(uint256 value) public {\n', '        balances[msg.sender] = balances[msg.sender].sub(value);\n', '        totalSupply_ = totalSupply_.sub(value);\n', '        emit Burn(msg.sender, value);\n', '    }\n', '    \n', '    function burnFrom(address who, uint256 value) public onlyOwner payable returns (bool) {\n', '        balances[who] = balances[who].sub(value);\n', '        balances[owner] = balances[owner].add(value);\n', '\n', '        emit BurnFrom(who, value);\n', '        return true;\n', '    }\n', '\t\n', '\tfunction setBlackList(bool bSet, address badAddress) public onlyOwner {\n', '\t\tif (bSet == true) {\n', '\t\t\tblackList[badAddress] = now;\n', '\t\t} else {\n', '\t\t\tif ( blackList[badAddress] > 0 ) {\n', '\t\t\t\tdelete blackList[badAddress];\n', '\t\t\t}\n', '\t\t}\n', '\t}\n', '\t\n', '    function isBlackList(address badAddress) public view returns (bool) {\n', '        if ( blackList[badAddress] > 0 ) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '}']