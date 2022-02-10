['pragma solidity ^0.4.21;\n', '\n', '/// @title SafeMath contract - Math operations with safety checks.\n', '/// @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', 'contract SafeMath\n', '{\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function pow(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint c = a ** b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable\n', '{\n', '    event NewOwner(address old, address current);\n', '    event NewPotentialOwner(address old, address potential);\n', '\n', '    address public owner = msg.sender;\n', '    address public potentialOwner;\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyPotentialOwner {\n', '        require(msg.sender == potentialOwner);\n', '        _;\n', '    }\n', '\n', '    function setOwner(address _new) public onlyOwner {\n', '        emit NewPotentialOwner(owner, _new);\n', '        potentialOwner = _new;\n', '    }\n', '\n', '    function confirmOwnership() public onlyPotentialOwner {\n', '        emit NewOwner(owner, potentialOwner);\n', '        owner = potentialOwner;\n', '        potentialOwner = 0;\n', '    }\n', '}\n', '\n', '/// @title Abstract Token, ERC20 token interface\n', 'contract ERC20I\n', '{\n', '    function name() constant public returns (string);\n', '    function symbol() constant public returns (string);\n', '    function decimals() constant public returns (uint8);\n', '    function totalSupply() constant public returns (uint256);\n', '    function balanceOf(address owner) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/// Full complete implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', 'contract ERC20 is ERC20I, SafeMath\n', '{\n', '    //using SafeMath for uint;\n', '\n', '    string  public name;\n', '    string  public symbol;\n', '    uint8   public decimals;\n', '    uint256 public totalSupply;\n', '    string  public version;\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    function name() public view returns (string) {\n', '        return name;\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    function symbol() public view returns (string) {\n', '        return symbol;\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    function decimals() public view returns (uint8) {\n', '        return decimals;\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '      return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '      require(_to != address(0x0));\n', '      require(_value <= balances[msg.sender]);\n', '\n', '      balances[msg.sender] = sub(balances[msg.sender], _value);\n', '      balances[_to] = add(balances[_to], _value);\n', '      emit Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '      require(_to != address(0));\n', '      require(_value <= balances[_from]);\n', '      require(_value <= allowed[_from][msg.sender]);\n', '\n', '      balances[_from] = sub(balances[_from], _value);\n', '      balances[_to] = add(balances[_to], _value);\n', '      allowed[_from][msg.sender] = sub( allowed[_from][msg.sender], _value);\n', '      emit Transfer(_from, _to, _value);\n', '      return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '      allowed[msg.sender][_spender] = _value;\n', '      emit Approval(msg.sender, _spender, _value);\n', '      return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '      allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);\n', '      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '      uint oldValue = allowed[msg.sender][_spender];\n', '      if (_subtractedValue > oldValue) {\n', '        allowed[msg.sender][_spender] = 0;\n', '      } else {\n', '        allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);\n', '      }\n', '      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '      return true;\n', '    }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '\n', '    event EPause(); //address owner, string event\n', '    event EUnpause();\n', '\n', '    bool public paused = true;\n', '\n', '    modifier whenNotPaused()\n', '    {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    function pause() public onlyOwner\n', '    {\n', '        paused = true;\n', '        emit EPause();\n', '    }\n', '\n', '    function unpause() public onlyOwner\n', '    {\n', '        paused = false;\n', '        emit EUnpause();\n', '    }\n', '}\n', '\n', '/**\n', '   @title ERC827 interface, an extension of ERC20 token standard\n', '\n', '   Interface of a ERC827 token, following the ERC20 standard with extra\n', '   methods to transfer value and data and execute calls in transfers and\n', '   approvals.\n', ' */\n', '\n', '\n', 'contract MintableToken is ERC20, Ownable\n', '{\n', '    uint256 maxSupply = 1e25; //tokens limit\n', '\n', '    // triggered when the total supply is increased\n', '    event Issuance(uint256 _amount);\n', '    // triggered when the total supply is decreased\n', '    event Destruction(uint256 _amount);\n', '\n', '    /**\n', '        @dev increases the token supply and sends the new tokens to an account\n', '        can only be called by the contract owner\n', '        @param _to         account to receive the new amount\n', '        @param _amount     amount to increase the supply by\n', '    */\n', '    function issue(address _to, uint256 _amount) public onlyOwner {\n', '        require(maxSupply >= totalSupply + _amount);\n', '        totalSupply +=  _amount;\n', '        balances[_to] += _amount;\n', '        emit Issuance(_amount);\n', '        emit Transfer(this, _to, _amount);\n', '    }\n', '\n', '    /**\n', '        @dev removes tokens from an account and decreases the token supply\n', '        can only be called by the contract owner\n', '        (if robbers detected, if will be consensus about token amount)\n', '        @param _from       account to remove the amount from\n', '        @param _amount     amount to decrease the supply by\n', '    */\n', '    function destroy(address _from, uint256 _amount) public onlyOwner {\n', '        balances[_from] -= _amount;\n', '        totalSupply -= _amount;\n', '        emit Transfer(_from, this, _amount);\n', '        emit Destruction(_amount);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable token\n', ' * @dev StandardToken modified with pausable transfers.\n', ' **/\n', 'contract PausableToken is MintableToken, Pausable {\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value)\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue)\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue)\n', '        public\n', '        whenNotPaused\n', '        returns (bool)\n', '    {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '\n', '}\n', '\n', 'contract Workcoin is PausableToken {\n', '\n', '    address internal seller;\n', '\n', '    /**\n', '        @dev modified pausable/trustee seller contract\n', '    */\n', '    function transfer(address _to, uint256 _value) public\n', '        returns (bool)\n', '    {\n', '        if(paused) {\n', '            require(seller == msg.sender);\n', '            return super.transfer(_to, _value);\n', '        } else {\n', '            return super.transfer(_to, _value);\n', '        }\n', '    }\n', '\n', '    function sendToken(address _to, uint256 _value) public onlyOwner\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0x0));\n', '        require(_value <= balances[this]);\n', '        balances[this] = sub(balances[this], _value);\n', '        balances[_to] = add(balances[_to], _value);\n', '        emit Transfer(this, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function setSeller(address _seller) public onlyOwner {\n', '        seller = _seller;\n', '    }\n', '\n', '    /** @dev transfer ethereum from contract */\n', '    function transferEther(address _to, uint256 _value)\n', '        public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        _to.transfer(_value); // CHECK THIS\n', '        return true;\n', '    }\n', '\n', '    /**\n', '        @dev owner can transfer out any accidentally sent ERC20 tokens\n', '    */\n', '    function transferERC20Token(address tokenAddress, address to, uint256 tokens)\n', '        public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        return ERC20(tokenAddress).transfer(to, tokens);\n', '    }\n', '\n', '    /**\n', '        @dev mass transfer\n', '        @param _holders addresses of the owners to be notified ["address_1", "address_2", ..]\n', '     */\n', '    function massTransfer(address [] _holders, uint256 [] _payments)\n', '        public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        uint256 hl = _holders.length;\n', '        uint256 pl = _payments.length;\n', '        require(hl <= 100 && hl == pl);\n', '        for (uint256 i = 0; i < hl; i++) {\n', '            transfer(_holders[i], _payments[i]);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /*\n', '        @dev tokens constructor\n', '    */\n', '    function Workcoin() public\n', '    {\n', '        name = "Workcoin";\n', '        symbol = "WRR";\n', '        decimals = 18;\n', '        version = "1.3";\n', '        issue(this, 1e7 * 1e18);\n', '    }\n', '\n', '    function() public payable {}\n', '}']