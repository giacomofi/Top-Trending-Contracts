['pragma solidity ^0.5.1;\n', '\n', '/*\n', '    email \n', '    info@realt.to\n', '\n', '    Facebbok \n', '    https://www.facebook.com/Real-T-323544031677341/\n', '\n', '    Twitter \n', '    https://twitter.com/realtstable\n', '**/\n', '\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    /**\n', '      * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '      * account.\n', '      */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '      * @dev Throws if called by any account other than the owner.\n', '      */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Sender is not the owner.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '    uint public _totalSupply;\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address who) public view returns (uint);\n', '    function transfer(address to, uint value) public;\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint);\n', '    function transferFrom(address from, address to, uint value) public;\n', '    function approve(address spender, uint value) public;\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is Ownable, ERC20Basic {\n', '    using SafeMath for uint;\n', '\n', '    mapping(address => uint) public balances;\n', '\n', '    /**\n', '    * @dev Fix for the ERC20 short address attack.\n', '    */\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(!(msg.data.length < size + 4), "Payload size is incorrect.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {\n', '        require(_to != address(0), "_to address is invalid.");\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '    mapping (address => mapping (address => uint)) public allowed;\n', '\n', '    uint public constant MAX_UINT = 2**256 - 1;\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {\n', '        require(_from != address(0), "_from address is invalid.");\n', '        require(_to != address(0), "_to address is invalid.");\n', '\n', '        uint _allowance = allowed[_from][msg.sender];\n', '\n', '        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '        // if (_value > _allowance) throw;\n', '\n', '        if (_allowance < MAX_UINT) {\n', '            allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        }\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)), "Invalid function arguments.");\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is not paused.\n', '    */\n', '    modifier whenNotPaused() {\n', '        require(!paused, "Token is paused.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is paused.\n', '    */\n', '    modifier whenPaused() {\n', '        require(paused, "Token is unpaused.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to pause, triggers stopped state\n', '    */\n', '    function pause() public onlyOwner whenNotPaused {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to unpause, returns to normal state\n', '    */\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract REALT is Pausable, StandardToken {\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint public decimals;\n', '\n', '    mapping(address => bool) public authorized;\n', '    mapping(address => bool) public blacklisted;\n', '\n', '    //  The contract can be initialized with a number of tokens\n', '    //  All the tokens are deposited to the owner address\n', '    //\n', '    // @param _balance Initial supply of the contract\n', '    // @param _name Token Name\n', '    // @param _symbol Token symbol\n', '    // @param _decimals Token decimals\n', '    constructor() public {\n', '        name = "REAL-T";\n', '        symbol = "REALT";\n', '        decimals = 4;\n', '        setAuthorization(0xd17Ecd9F35cBfd9f673Cb4E6aC6Ce5fcCD084dd9);\n', '        transferOwnership(0xd17Ecd9F35cBfd9f673Cb4E6aC6Ce5fcCD084dd9);\n', '    }\n', '\n', '    modifier onlyAuthorized() {\n', '        require(authorized[msg.sender], "msg.sender is not authorized");\n', '        _;\n', '    }\n', '\n', '    event AuthorizationSet(address _address);\n', '    function setAuthorization(address _address) public onlyOwner {\n', '        require(_address != address(0), "Provided address is invalid.");\n', '        require(!authorized[_address], "Address is already authorized.");\n', '        \n', '        authorized[_address] = true;\n', '\n', '        emit AuthorizationSet(_address);\n', '    }\n', '\n', '    event AuthorizationRevoked(address _address);\n', '    function revokeAuthorization(address _address) public onlyOwner {\n', '        require(_address != address(0), "Provided address is invalid.");\n', '        require(authorized[_address], "Address is already unauthorized.");\n', '\n', '        authorized[_address] = false;\n', '\n', '        emit AuthorizationRevoked(_address);\n', '    }\n', '\n', '    modifier NotBlacklisted(address _address) {\n', '        require(!blacklisted[_address], "The provided address is blacklisted.");\n', '        _;\n', '    }\n', '    \n', '    event BlacklistAdded(address _address);\n', '    function addBlacklist(address _address) public onlyAuthorized {\n', '        require(_address != address(0), "Provided address is invalid.");\n', '        require(!blacklisted[_address], "The provided address is already blacklisted");\n', '        blacklisted[_address] = true;\n', '        \n', '        emit BlacklistAdded(_address);\n', '    }\n', '\n', '    event BlacklistRemoved(address _address);\n', '    function removeBlacklist(address _address) public onlyAuthorized {\n', '        require(_address != address(0), "Provided address is invalid.");\n', '        require(blacklisted[_address], "The provided address is already not blacklisted");\n', '        blacklisted[_address] = false;\n', '        \n', '        emit BlacklistRemoved(_address);\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) public NotBlacklisted(_to) NotBlacklisted(msg.sender) whenNotPaused {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public NotBlacklisted(_to) NotBlacklisted(_from) NotBlacklisted(msg.sender) whenNotPaused {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function balanceOf(address who) public view returns (uint) {\n', '        return super.balanceOf(who);\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return super.allowance(_owner, _spender);\n', '    }\n', '\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // Issue a new amount of tokens\n', '    // these tokens are deposited into the owner address\n', '    //\n', '    // @param _amount Number of tokens to be issued\n', '    function issue(uint amount) public onlyAuthorized {\n', '        _totalSupply = _totalSupply.add(amount);\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '        \n', '        emit Issue(amount);\n', '    }\n', '\n', '    // Redeem tokens.\n', '    // These tokens are withdrawn from the owner address\n', '    // if the balance must be enough to cover the redeem\n', '    // or the call will fail.\n', '    // @param _amount Number of tokens to be issued\n', '    function redeem(uint amount) public onlyAuthorized {\n', '        require(_totalSupply >= amount, "Redeem amount is greater than total supply.");\n', '        require(balances[msg.sender] >= amount, "Redeem amount is greater than sender\'s balance.");\n', '\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(amount);\n', '        emit Redeem(amount);\n', '    }\n', '\n', '    // Called when new token are issued\n', '    event Issue(uint amount);\n', '\n', '    // Called when tokens are redeemed\n', '    event Redeem(uint amount);\n', '\n', '}']