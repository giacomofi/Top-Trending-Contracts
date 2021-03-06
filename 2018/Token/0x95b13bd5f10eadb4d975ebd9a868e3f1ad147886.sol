['pragma solidity ^0.4.13;\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        balances[_who] = balances[_who] - _value;\n', '        totalSupply_ = totalSupply_ - _value;\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract DetailedERC20 is ERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    constructor (string _name, string _symbol, uint8 _decimals) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amount of tokens to be transferred\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from] - _value;\n', '        balances[_to] = balances[_to] + _value;\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    *\n', '    * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '    * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifying the amount of tokens still available for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    *\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _addedValue The amount of tokens to increase the allowance by.\n', '    */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        uint allowanceBefore = allowed[msg.sender][_spender];\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;\n', '        assert(allowanceBefore <= allowed[msg.sender][_spender]);\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '    *\n', '    * approve should be called when allowed[_spender] == 0. To decrement\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '    */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue - _subtractedValue;\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', 'contract StandardBurnableToken is BurnableToken, StandardToken {\n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens from the target address and decrements allowance\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _value uint256 The amount of token to be burned\n', '    */\n', '    function burnFrom(address _from, uint256 _value) public {\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '        // this function needs to emit an event with the updated approval.\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;\n', '        _burn(_from, _value);\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract SoundeonTokenDistributor is Ownable {\n', '    SoundeonToken public token;\n', '\n', '    mapping(uint32 => bool) public processedTransactions;\n', '\n', '    constructor(SoundeonToken _token) public {\n', '        token = _token == address(0x0) ? new SoundeonToken() : _token;\n', '    }\n', '\n', '    function isTransactionSuccessful(uint32 id) external view returns (bool) {\n', '        return processedTransactions[id];\n', '    }\n', '\n', '    modifier validateInput(uint32[] _payment_ids, address[] _receivers, uint256[] _amounts) {\n', '        require(_receivers.length == _amounts.length);\n', '        require(_receivers.length == _payment_ids.length);\n', '\n', '        _;\n', '    }\n', '\n', '    function transferTokenOwnership() external onlyOwner {\n', '        token.transferOwnership(owner);\n', '    }\n', '}\n', '\n', 'contract SoundeonTokenMinter is SoundeonTokenDistributor {\n', '    address public reserveFundAddress = 0x5C7F38190c1E14aDB8c421886B196e7072B6356E;\n', '    address public artistManifestoFundAddress = 0xC94BBB49E139EAbA8Dc4EA8b0ae5066f9DFEEcEf;\n', '    address public bountyPoolAddress = 0x252a30D338E9dfd30042CEfA8bbd6C3CaF040443;\n', '    address public earlyBackersPoolAddress = 0x07478916c9effbc95b7D6C8F99E52B0fcC35a091;\n', '    address public teamPoolAddress = 0x3B467C1bD8712aA1182eced58a75b755d0314a65;\n', '    address public advisorsAndAmbassadorsAddress = 0x0e16D22706aB5b1Ec374d31bb3e27d04Cc07f9D8;\n', '\n', '    constructor(SoundeonToken _token) SoundeonTokenDistributor(_token) public { }\n', '\n', '    function bulkMint(uint32[] _payment_ids, address[] _receivers, uint256[] _amounts)\n', '        external onlyOwner validateInput(_payment_ids, _receivers, _amounts) {\n', '        uint totalAmount = 0;\n', '\n', '        for (uint i = 0; i < _receivers.length; i++) {\n', '            require(_receivers[i] != address(0));\n', '\n', '            if (!processedTransactions[_payment_ids[i]]) {\n', '                processedTransactions[_payment_ids[i]] = true;\n', '\n', '                token.mint(_receivers[i], _amounts[i]);\n', '\n', '                totalAmount += _amounts[i] / 65;\n', '            }\n', '        }\n', '\n', '        require(token.mint(reserveFundAddress, totalAmount * 2));\n', '        require(token.mint(artistManifestoFundAddress, totalAmount * 6));\n', '        require(token.mint(bountyPoolAddress, totalAmount * 3));\n', '        require(token.mint(teamPoolAddress, totalAmount * 14));\n', '        require(token.mint(earlyBackersPoolAddress, totalAmount * 4));\n', '        require(token.mint(advisorsAndAmbassadorsAddress, totalAmount * 6));\n', '    }\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '\n', '    modifier canMint() {\n', '        require(!mintingFinished);\n', '\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '        totalSupply_ = totalSupply_ + _amount;\n', '        balances[_to] = balances[_to] + _amount;\n', '\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop minting new tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract CappedToken is MintableToken {\n', '\n', '    uint256 public cap;\n', '\n', '    constructor(uint256 _cap) public {\n', '        require(_cap > 0);\n', '\n', '        cap = _cap;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '        require(totalSupply_ + _amount <= cap);\n', '        require(totalSupply_ + _amount >= totalSupply_);\n', '\n', '        return super.mint(_to, _amount);\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is not paused.\n', '    */\n', '    modifier whenNotPaused() {\n', '        require(!paused || msg.sender == owner);\n', '\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Modifier to make a function callable only when the contract is paused.\n', '    */\n', '    modifier whenPaused() {\n', '        require(paused || msg.sender == owner);\n', '\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to pause, triggers stopped state\n', '    */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '    * @dev called by the owner to unpause, returns to normal state\n', '    */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract PausableToken is StandardToken, Pausable {\n', '\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', 'contract SoundeonToken is StandardBurnableToken, CappedToken, DetailedERC20, PausableToken  {\n', '    constructor() CappedToken(10**27) DetailedERC20("Soundeon Token", "Soundeon", 18) public {\n', '    }\n', '}']