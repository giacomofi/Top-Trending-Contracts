['/*\n', ' * This file was generated by MyWish Platform (https://mywish.io/)\n', ' * The complete code could be found at https://github.com/MyWishPlatform/\n', ' * Copyright (C) 2018 MyWish\n', ' *\n', ' * This program is free software: you can redistribute it and/or modify\n', ' * it under the terms of the GNU Lesser General Public License as published by\n', ' * the Free Software Foundation, either version 3 of the License, or\n', ' * (at your option) any later version.\n', ' *\n', ' * This program is distributed in the hope that it will be useful,\n', ' * but WITHOUT ANY WARRANTY; without even the implied warranty of\n', ' * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n', ' * GNU Lesser General Public License for more details.\n', ' *\n', ' * You should have received a copy of the GNU Lesser General Public License\n', ' * along with this program. If not, see <http://www.gnu.org/licenses/>.\n', ' */\n', '\n', 'pragma solidity ^0.4.20;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Mintable token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  bool public mintingFinished = false;\n', '\n', '\n', '  modifier canMint() {\n', '    require(!mintingFinished);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(address(0), _to, _amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to stop minting new tokens.\n', '   * @return True if the operation was successful.\n', '   */\n', '  function finishMinting() onlyOwner canMint public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract FreezableToken is StandardToken {\n', '    // freezing chains\n', '    mapping (bytes32 => uint64) internal chains;\n', '    // freezing amounts for each chain\n', '    mapping (bytes32 => uint) internal freezings;\n', '    // total freezing balance per address\n', '    mapping (address => uint) internal freezingBalance;\n', '\n', '    event Freezed(address indexed to, uint64 release, uint amount);\n', '    event Released(address indexed owner, uint amount);\n', '\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address include freezing tokens.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return super.balanceOf(_owner) + freezingBalance[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address without freezing tokens.\n', '     * @param _owner The address to query the the balance of.\n', '     * @return An uint256 representing the amount owned by the passed address.\n', '     */\n', '    function actualBalanceOf(address _owner) public view returns (uint256 balance) {\n', '        return super.balanceOf(_owner);\n', '    }\n', '\n', '    function freezingBalanceOf(address _owner) public view returns (uint256 balance) {\n', '        return freezingBalance[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev gets freezing count\n', '     * @param _addr Address of freeze tokens owner.\n', '     */\n', '    function freezingCount(address _addr) public view returns (uint count) {\n', '        uint64 release = chains[toKey(_addr, 0)];\n', '        while (release != 0) {\n', '            count ++;\n', '            release = chains[toKey(_addr, release)];\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev gets freezing end date and freezing balance for the freezing portion specified by index.\n', '     * @param _addr Address of freeze tokens owner.\n', '     * @param _index Freezing portion index. It ordered by release date descending.\n', '     */\n', '    function getFreezing(address _addr, uint _index) public view returns (uint64 _release, uint _balance) {\n', '        for (uint i = 0; i < _index + 1; i ++) {\n', '            _release = chains[toKey(_addr, _release)];\n', '            if (_release == 0) {\n', '                return;\n', '            }\n', '        }\n', '        _balance = freezings[toKey(_addr, _release)];\n', '    }\n', '\n', '    /**\n', '     * @dev freeze your tokens to the specified address.\n', '     *      Be careful, gas usage is not deterministic,\n', '     *      and depends on how many freezes _to address already has.\n', '     * @param _to Address to which token will be freeze.\n', '     * @param _amount Amount of token to freeze.\n', '     * @param _until Release date, must be in future.\n', '     */\n', '    function freezeTo(address _to, uint _amount, uint64 _until) public {\n', '        require(_to != address(0));\n', '        require(_amount <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '\n', '        bytes32 currentKey = toKey(_to, _until);\n', '        freezings[currentKey] = freezings[currentKey].add(_amount);\n', '        freezingBalance[_to] = freezingBalance[_to].add(_amount);\n', '\n', '        freeze(_to, _until);\n', '        Transfer(msg.sender, _to, _amount);\n', '        Freezed(_to, _until, _amount);\n', '    }\n', '\n', '    /**\n', '     * @dev release first available freezing tokens.\n', '     */\n', '    function releaseOnce() public {\n', '        bytes32 headKey = toKey(msg.sender, 0);\n', '        uint64 head = chains[headKey];\n', '        require(head != 0);\n', '        require(uint64(block.timestamp) > head);\n', '        bytes32 currentKey = toKey(msg.sender, head);\n', '\n', '        uint64 next = chains[currentKey];\n', '\n', '        uint amount = freezings[currentKey];\n', '        delete freezings[currentKey];\n', '\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '        freezingBalance[msg.sender] = freezingBalance[msg.sender].sub(amount);\n', '\n', '        if (next == 0) {\n', '            delete chains[headKey];\n', '        }\n', '        else {\n', '            chains[headKey] = next;\n', '            delete chains[currentKey];\n', '        }\n', '        Released(msg.sender, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev release all available for release freezing tokens. Gas usage is not deterministic!\n', '     * @return how many tokens was released\n', '     */\n', '    function releaseAll() public returns (uint tokens) {\n', '        uint release;\n', '        uint balance;\n', '        (release, balance) = getFreezing(msg.sender, 0);\n', '        while (release != 0 && block.timestamp > release) {\n', '            releaseOnce();\n', '            tokens += balance;\n', '            (release, balance) = getFreezing(msg.sender, 0);\n', '        }\n', '    }\n', '\n', '    function toKey(address _addr, uint _release) internal pure returns (bytes32 result) {\n', '        // WISH masc to increase entropy\n', '        result = 0x5749534800000000000000000000000000000000000000000000000000000000;\n', '        assembly {\n', '            result := or(result, mul(_addr, 0x10000000000000000))\n', '            result := or(result, _release)\n', '        }\n', '    }\n', '\n', '    function freeze(address _to, uint64 _until) internal {\n', '        require(_until > block.timestamp);\n', '        bytes32 key = toKey(_to, _until);\n', '        bytes32 parentKey = toKey(_to, uint64(0));\n', '        uint64 next = chains[parentKey];\n', '\n', '        if (next == 0) {\n', '            chains[parentKey] = _until;\n', '            return;\n', '        }\n', '\n', '        bytes32 nextKey = toKey(_to, next);\n', '        uint parent;\n', '\n', '        while (next != 0 && _until > next) {\n', '            parent = next;\n', '            parentKey = nextKey;\n', '\n', '            next = chains[nextKey];\n', '            nextKey = toKey(_to, next);\n', '        }\n', '\n', '        if (_until == next) {\n', '            return;\n', '        }\n', '\n', '        if (next != 0) {\n', '            chains[key] = next;\n', '        }\n', '\n', '        chains[parentKey] = _until;\n', '    }\n', '}\n', '\n', '/**\n', '* @title Contract that will work with ERC223 tokens.\n', '*/\n', '\n', 'contract ERC223Receiver {\n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', 'contract ERC223Basic is ERC20Basic {\n', '    function transfer(address to, uint value, bytes data) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '}\n', '\n', '\n', 'contract SuccessfulERC223Receiver is ERC223Receiver {\n', '    event Invoked(address from, uint value, bytes data);\n', '\n', '    function tokenFallback(address _from, uint _value, bytes _data) public {\n', '        Invoked(_from, _value, _data);\n', '    }\n', '}\n', '\n', 'contract FailingERC223Receiver is ERC223Receiver {\n', '    function tokenFallback(address, uint, bytes) public {\n', '        revert();\n', '    }\n', '}\n', '\n', 'contract ERC223ReceiverWithoutTokenFallback {\n', '}\n', '\n', '/**\n', ' * @title Burnable Token\n', ' * @dev Token that can be irreversibly burned (destroyed).\n', ' */\n', 'contract BurnableToken is StandardToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        require(_value > 0);\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract FreezableMintableToken is FreezableToken, MintableToken {\n', '    /**\n', '     * @dev Mint the specified amount of token to the specified address and freeze it until the specified date.\n', '     *      Be careful, gas usage is not deterministic,\n', '     *      and depends on how many freezes _to address already has.\n', '     * @param _to Address to which token will be freeze.\n', '     * @param _amount Amount of token to mint and freeze.\n', '     * @param _until Release date, must be in future.\n', '     * @return A boolean that indicates if the operation was successful.\n', '     */\n', '    function mintAndFreeze(address _to, uint _amount, uint64 _until) onlyOwner canMint public returns (bool) {\n', '        totalSupply = totalSupply.add(_amount);\n', '\n', '        bytes32 currentKey = toKey(_to, _until);\n', '        freezings[currentKey] = freezings[currentKey].add(_amount);\n', '        freezingBalance[_to] = freezingBalance[_to].add(_amount);\n', '\n', '        freeze(_to, _until);\n', '        Mint(_to, _amount);\n', '        Freezed(_to, _until, _amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Consts {\n', '    uint constant TOKEN_DECIMALS = 18;\n', '    uint8 constant TOKEN_DECIMALS_UINT8 = 18;\n', '    uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;\n', '\n', '    string constant TOKEN_NAME = "securix.io";\n', '    string constant TOKEN_SYMBOL = "SRXIO";\n', '    bool constant PAUSED = false;\n', '    address constant TARGET_USER = 0x59f66832EfdAd39AF88A5aF420E7E546C5838D5b;\n', '    \n', '    bool constant CONTINUE_MINTING = true;\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Reference implementation of the ERC223 standard token.\n', ' */\n', 'contract ERC223Token is ERC223Basic, BasicToken, FailingERC223Receiver {\n', '    using SafeMath for uint;\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      Invokes the `tokenFallback` function if the recipient is a contract.\n', '     *      The token transfer fails if the recipient is a contract\n', '     *      but does not implement the `tokenFallback` function\n', '     *      or the fallback function to receive funds.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function transfer(address _to, uint _value, bytes _data) public returns (bool) {\n', '        // Standard function transfer similar to ERC20 transfer with no _data .\n', '        // Added due to backwards compatibility reasons .\n', '        uint codeLength;\n', '\n', '        assembly {\n', '            // Retrieve the size of the code on target address, this needs assembly.\n', '            codeLength := extcodesize(_to)\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(codeLength > 0) {\n', '            ERC223Receiver receiver = ERC223Receiver(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '        Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer the specified amount of tokens to the specified address.\n', '     *      This function works the same with the previous one\n', '     *      but doesn&#39;t contain `_data` param.\n', '     *      Added due to backwards compatibility reasons.\n', '     *\n', '     * @param _to    Receiver address.\n', '     * @param _value Amount of tokens that will be transferred.\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        bytes memory empty;\n', '        return transfer(_to, _value, empty);\n', '    }\n', '}\n', '\n', '\n', 'contract MainToken is Consts, FreezableMintableToken, BurnableToken, Pausable\n', '    \n', '{\n', '    \n', '    event Initialized();\n', '    bool public initialized = false;\n', '\n', '    function MainToken() public {\n', '        init();\n', '        transferOwnership(TARGET_USER);\n', '    }\n', '\n', '    function init() private {\n', '        require(!initialized);\n', '        initialized = true;\n', '\n', '        if (PAUSED) {\n', '            pause();\n', '        }\n', '\n', '        \n', '        address[4] memory addresses = [address(0xdd7f7de0dc651940271f7a027e92a5ca6de67b32),address(0xb692ee46285c326226f3920a78d34450a7724b3f),address(0x0092b8c894047f8a8c2a23e52ce47ccfa5c6b516),address(0x1216026d620562189d10c98278d3d7c373ddb5d4)];\n', '        uint[4] memory amounts = [uint(5000000000000000000000000),uint(1000000000000000000000000),uint(3000000000000000000000000),uint(41000000000000000000000000)];\n', '        uint64[4] memory freezes = [uint64(0),uint64(0),uint64(0),uint64(0)];\n', '\n', '        for (uint i = 0; i < addresses.length; i++) {\n', '            if (freezes[i] == 0) {\n', '                mint(addresses[i], amounts[i]);\n', '            } else {\n', '                mintAndFreeze(addresses[i], amounts[i], freezes[i]);\n', '            }\n', '        }\n', '        \n', '\n', '        if (!CONTINUE_MINTING) {\n', '            finishMinting();\n', '        }\n', '\n', '        Initialized();\n', '    }\n', '    \n', '\n', '    function name() pure public returns (string _name) {\n', '        return TOKEN_NAME;\n', '    }\n', '\n', '    function symbol() pure public returns (string _symbol) {\n', '        return TOKEN_SYMBOL;\n', '    }\n', '\n', '    function decimals() pure public returns (uint8 _decimals) {\n', '        return TOKEN_DECIMALS_UINT8;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {\n', '        require(!paused);\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool _success) {\n', '        require(!paused);\n', '        return super.transfer(_to, _value);\n', '    }\n', '}']