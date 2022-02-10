['pragma solidity ^0.4.15;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Token {\n', '\n', '    /// @return total amount of tokens\n', '    //function totalSupply() constant returns (uint256 supply);\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '}\n', '\n', '\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', '\n', '//name this contract whatever you&#39;d like\n', 'contract LUVTOKEN is StandardToken {\n', '\n', '    function () {\n', '        //if ether is sent to this address, send it back.\n', '        revert();\n', '    }\n', '\n', '    /* Public variables of the token */\n', '\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customize the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name;                   //fancy name: eg Simon Bucks\n', '    uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It&#39;s like comparing 1 wei to 1 ether.\n', '    string public symbol;                 //An identifier: eg SBX\n', '    string public version = &#39;H1.0&#39;;       //human 0.1 standard. Just an arbitrary versioning scheme.\n', '\n', '//\n', '// CHANGE THESE VALUES FOR YOUR TOKEN\n', '//\n', '\n', '//make sure this function name matches the contract name above. So if you&#39;re token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token\n', '\n', '    function LUVTOKEN(\n', '        ) {\n', '        decimals = 0; \n', '        totalSupply = 200000000;                        // Update total supply (100000 for example)\n', '        balances[msg.sender] = totalSupply;               // Give the creator all initial tokens (100000 for example)\n', '        name = "LUVTOKEN";                                   // Set the name for display purposes\n', '        symbol = "LUV";                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Token \n', ' * @dev API interface for interacting with the LUVTOKEN contract\n', ' * /\n', ' interface Token {\n', ' function transfer (address _to, uint256 _value) returns (bool);\n', ' function balanceOf (address_owner) constant returns (uint256 balance);\n', '}\n', '\n', '/**\n', ' * @title LUV_Crowdsale\n', ' * @dev HDK_Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'contract LUV_Crowdsale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  // The token being sold\n', '  LUVTOKEN public token;\n', '\n', '  // start and end timestamps where investments are allowed (both inclusive)\n', '\n', '\n', '  uint256 public startTime = 1523750400;\n', '  uint256 public phase_1_Time = 1526342400 ;\n', '  uint256 public phase_2_Time = 1529020800;\n', '  uint256 public endTime = 1531612800;\n', '\n', '  // Max amount of wei accepted in the crowdsale\n', '  uint256 public cap;\n', '  \n', '  // Min amount of wei an investor can send\n', '  uint256 public minInvest;\n', '  \n', '  \n', '  // address where funds are collected\n', '  address public wallet;\n', '\n', '  // how many token units a buyer gets. 1 ETH = 10000 LUV\n', '  uint256 public phase_1_rate = 13000;\n', '  uint256 public phase_2_rate = 12000;\n', '  uint256 public phase_3_rate = 11000;\n', '  \n', '  \n', '  // amount of raised money in wei\n', '  uint256 public weiRaised;\n', '\n', '  mapping (address => uint256) rates;\n', '\n', '  function getRate() constant returns (uint256){\n', '    uint256 current_time = now;\n', '\n', '    if(current_time > startTime && current_time < phase_1_Time){\n', '      return phase_1_rate;\n', '    }\n', '    else if(current_time > phase_1_Time && current_time < phase_2_Time){\n', '      return phase_2_rate;\n', '    }\n', '      else if(current_time > phase_2_Time && current_time < endTime){\n', '      return phase_3_rate;\n', '    }\n', '      \n', '  }\n', '\n', '  /**\n', '   * event for token purchase logging\n', '   * @param purchaser who paid for the tokens\n', '   * @param beneficiary who got the tokens\n', '   * @param value weis paid for purchase\n', '   * @param amount amount of tokens purchased\n', '   */\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '\n', '  function LUV_Crowdsale() {\n', '    wallet = msg.sender;\n', '    token = createTokenContract();\n', '    minInvest = 0.1 * 1 ether;\n', '    cap = 100000 * 1 ether;\n', '  }\n', '\n', '  // creates the token to be sold.\n', '  // override this method to have crowdsale of a specific mintable token.\n', '  function createTokenContract() internal returns (LUVTOKEN) {\n', '    return new LUVTOKEN();\n', '  }\n', '\n', '\n', '  // fallback function can be used to buy tokens\n', '  function () payable {\n', '    buyTokens(msg.sender);\n', '  }\n', '\n', '  // low level token purchase function\n', '  function buyTokens(address beneficiary) public payable {\n', '    require(beneficiary != 0x0);\n', '    require(validPurchase());\n', '\n', '    uint256 weiAmount = msg.value;\n', '\n', '    // calculate token amount to be created\n', '    uint256 tokens = weiAmount.mul(getRate());\n', '\n', '    // update state\n', '    weiRaised = weiRaised.add(weiAmount);\n', '\n', '    token.transfer(beneficiary, tokens);\n', '    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);\n', '\n', '    forwardFunds();\n', '  }\n', '\n', '  // send ether to the fund collection wallet\n', '  // override to create custom fund forwarding mechanisms\n', '  function forwardFunds() internal {\n', '    wallet.transfer(msg.value);\n', '  }\n', '\n', '  // @return true if the transaction can buy tokens\n', '  function validPurchase() internal constant returns (bool) {\n', '    bool withinPeriod = now >= startTime && now <= endTime;\n', '    bool nonZeroPurchase = msg.value != 0;\n', '    return withinPeriod && nonZeroPurchase;\n', '  }\n', '\n', '  // @return true if crowdsale event has ended\n', '  function hasEnded() public constant returns (bool) {\n', '    return now > endTime;\n', '  }\n', '  \n', '/**\n', ' * @notice Terminate contract and refund to owner\n', ' */\n', ' function destroy() onlyOwner {\n', '     // Transfer tokens back to owner\n', '     uint256 balance = token.balanceOf(this);\n', '     assert (balance > 0);\n', '     token.transfer(owner,balance);\n', '     \n', '     // There should be no ether in the contract but just in case\n', '     selfdestruct(owner);\n', '     \n', ' }\n', '\n', '}']