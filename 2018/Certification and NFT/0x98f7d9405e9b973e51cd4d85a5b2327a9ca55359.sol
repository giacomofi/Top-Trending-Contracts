['pragma solidity ^0.4.17;\n', '\n', '//Slightly modified SafeMath library - includes a min function\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function min(uint a, uint b) internal pure returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', '//ERC20 function interface\n', 'interface ERC20_Interface {\n', '  function totalSupply() public constant returns (uint total_supply);\n', '  function balanceOf(address _owner) public constant returns (uint balance);\n', '  function transfer(address _to, uint _amount) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint _amount) public returns (bool success);\n', '  function approve(address _spender, uint _amount) public returns (bool success);\n', '  function allowance(address _owner, address _spender) public constant returns (uint amount);\n', '}\n', '\n', '//Swap factory functions - descriptions can be found in Factory.sol\n', 'interface Factory_Interface {\n', '  function createToken(uint _supply, address _party, bool _long, uint _start_date) public returns (address created, uint token_ratio);\n', '  function payToken(address _party, address _token_add) public;\n', '  function deployContract(uint _start_date) public payable returns (address created);\n', '   function getBase() public view returns(address _base1, address base2);\n', '  function getVariables() public view returns (address oracle_addr, uint swap_duration, uint swap_multiplier, address token_a_addr, address token_b_addr);\n', '}\n', '\n', '\n', '//DRCT_Token functions - descriptions can be found in DRCT_Token.sol\n', 'interface DRCT_Token_Interface {\n', '  function addressCount(address _swap) public constant returns (uint count);\n', '  function getHolderByIndex(uint _ind, address _swap) public constant returns (address holder);\n', '  function getBalanceByIndex(uint _ind, address _swap) public constant returns (uint bal);\n', '  function getIndexByAddress(address _owner, address _swap) public constant returns (uint index);\n', '  function createToken(uint _supply, address _owner, address _swap) public;\n', '  function pay(address _party, address _swap) public;\n', '  function partyCount(address _swap) public constant returns(uint count);\n', '}\n', '\n', '\n', '//Swap Oracle functions - descriptions can be found in Oracle.sol\n', 'interface Oracle_Interface{\n', '  function RetrieveData(uint _date) public view returns (uint data);\n', '}\n', '\n', '\n', '//This contract is the specific DRCT base contract that holds the funds of the contract and redistributes them based upon the change in the underlying values\n', 'contract TokenToTokenSwap {\n', '\n', '  using SafeMath for uint256;\n', '\n', '  /*Enums*/\n', '  //Describes various states of the Swap\n', '  enum SwapState {\n', '    created,\n', '    open,\n', '    started,\n', '    tokenized,\n', '    ready,\n', '    ended\n', '  }\n', '\n', '  /*Variables*/\n', '\n', '  //Address of the person who created this contract through the Factory\n', '  address creator;\n', '  //The Oracle address (check for list at www.github.com/DecentralizedDerivatives/Oracles)\n', '  address oracle_address;\n', '  Oracle_Interface oracle;\n', '\n', '  //Address of the Factory that created this contract\n', '  address public factory_address;\n', '  Factory_Interface factory;\n', '\n', '  //Addresses of parties going short and long the rate\n', '  address public long_party;\n', '  address public short_party;\n', '\n', '  //Enum state of the swap\n', '  SwapState public current_state;\n', '\n', '  //Start and end dates of the swaps - format is the same as block.timestamp\n', '  uint start_date;\n', '  uint end_date;\n', '\n', '  //This is the amount that the change will be calculated on.  10% change in rate on 100 Ether notional is a 10 Ether change\n', '  uint multiplier;\n', '\n', '  //This is the calculated share for the long and short side of the swap (200,000 is a fully capped move)\n', '  uint share_long;\n', '  uint share_short;\n', '\n', '  // pay_to_x refers to the amount of the base token (a or b) to pay to the long or short side based upon the share_long and share_short\n', '  uint pay_to_short_a;\n', '  uint pay_to_long_a;\n', '  uint pay_to_long_b;\n', '  uint pay_to_short_b;\n', '\n', '  //Address of created long and short DRCT tokens\n', '  address long_token_address;\n', '  address short_token_address;\n', '\n', '  //Number of DRCT Tokens distributed to both parties\n', '  uint num_DRCT_longtokens;\n', '  uint num_DRCT_shorttokens;\n', '\n', '  //Addresses of ERC20 tokens used to enter the swap\n', '  address token_a_address;\n', '  address token_b_address;\n', '\n', '  //Tokens A and B used for the notional\n', '  ERC20_Interface token_a;\n', '  ERC20_Interface token_b;\n', '\n', '  //The notional that the payment is calculated on from the change in the reference rate\n', '  uint public token_a_amount;\n', '  uint public token_b_amount;\n', '\n', '  uint public premium;\n', '\n', '  //Addresses of the two parties taking part in the swap\n', '  address token_a_party;\n', '  address token_b_party;\n', '\n', '  //Duration of the swap,pulled from the Factory contract\n', '  uint duration;\n', '  //Date by which the contract must be funded\n', '  uint enterDate;\n', '  DRCT_Token_Interface token;\n', '  address userContract;\n', '\n', '  /*Events*/\n', '\n', '  //Emitted when a Swap is created\n', '  event SwapCreation(address _token_a, address _token_b, uint _start_date, uint _end_date, address _creating_party);\n', '  //Emitted when the swap has been paid out\n', '  event PaidOut(address _long_token, address _short_token);\n', '\n', '  /*Modifiers*/\n', '\n', '  //Will proceed only if the contract is in the expected state\n', '  modifier onlyState(SwapState expected_state) {\n', '    require(expected_state == current_state);\n', '    _;\n', '  }\n', '\n', '  /*Functions*/\n', '\n', '  /*\n', '  * Constructor - Run by the factory at contract creation\n', '  *\n', '  * @param "_factory_address": Address of the factory that created this contract\n', '  * @param "_creator": Address of the person who created the contract\n', '  * @param "_userContract": Address of the _userContract that is authorized to interact with this contract\n', '  */\n', '  function TokenToTokenSwap (address _factory_address, address _creator, address _userContract, uint _start_date) public {\n', '    current_state = SwapState.created;\n', '    creator =_creator;\n', '    factory_address = _factory_address;\n', '    userContract = _userContract;\n', '    start_date = _start_date;\n', '  }\n', '\n', '\n', '  //A getter function for retriving standardized variables from the factory contract\n', '  function showPrivateVars() public view returns (address _userContract, uint num_DRCT_long, uint numb_DRCT_short, uint swap_share_long, uint swap_share_short, address long_token_addr, address short_token_addr, address oracle_addr, address token_a_addr, address token_b_addr, uint swap_multiplier, uint swap_duration, uint swap_start_date, uint swap_end_date){\n', '    return (userContract, num_DRCT_longtokens, num_DRCT_shorttokens,share_long,share_short,long_token_address,short_token_address, oracle_address, token_a_address, token_b_address, multiplier, duration, start_date, end_date);\n', '  }\n', '\n', '  /*\n', '  * Allows the sender to create the terms for the swap\n', '  * @param "_amount_a": Amount of Token A that should be deposited for the notional\n', '  * @param "_amount_b": Amount of Token B that should be deposited for the notional\n', '  * @param "_sender_is_long": Denotes whether the sender is set as the short or long party\n', '  * @param "_senderAdd": States the owner of this side of the contract (does not have to be msg.sender)\n', '  */\n', '  function CreateSwap(\n', '    uint _amount_a,\n', '    uint _amount_b,\n', '    bool _sender_is_long,\n', '    address _senderAdd\n', '    ) payable public onlyState(SwapState.created) {\n', '\n', '    require(\n', '      msg.sender == creator || (msg.sender == userContract && _senderAdd == creator)\n', '    );\n', '    factory = Factory_Interface(factory_address);\n', '    setVars();\n', '    end_date = start_date.add(duration.mul(86400));\n', '    token_a_amount = _amount_a;\n', '    token_b_amount = _amount_b;\n', '\n', '    premium = this.balance;\n', '    token_a = ERC20_Interface(token_a_address);\n', '    token_a_party = _senderAdd;\n', '    if (_sender_is_long)\n', '      long_party = _senderAdd;\n', '    else\n', '      short_party = _senderAdd;\n', '    current_state = SwapState.open;\n', '  }\n', '\n', '  function setVars() internal{\n', '      (oracle_address,duration,multiplier,token_a_address,token_b_address) = factory.getVariables();\n', '  }\n', '\n', '  /*\n', '  * This function is for those entering the swap. The details of the swap are re-entered and checked\n', '  * to ensure the entering party is entering the correct swap. Note that the tokens you are entering with\n', '  * do not need to be entered as a variable, but you should ensure that the contract is funded.\n', '  *\n', '  * @param: all parameters have the same functions as those in the CreateSwap function\n', '  */\n', '  function EnterSwap(\n', '    uint _amount_a,\n', '    uint _amount_b,\n', '    bool _sender_is_long,\n', '    address _senderAdd\n', '    ) public onlyState(SwapState.open) {\n', '\n', '    //Require that all of the information of the swap was entered correctly by the entering party.  Prevents partyA from exiting and changing details\n', '    require(\n', '      token_a_amount == _amount_a &&\n', '      token_b_amount == _amount_b &&\n', '      token_a_party != _senderAdd\n', '    );\n', '\n', '    token_b = ERC20_Interface(token_b_address);\n', '    token_b_party = _senderAdd;\n', '\n', '    //Set the entering party as the short or long party\n', '    if (_sender_is_long) {\n', '      require(long_party == 0);\n', '      long_party = _senderAdd;\n', '    } else {\n', '      require(short_party == 0);\n', '      short_party = _senderAdd;\n', '    }\n', '\n', '    SwapCreation(token_a_address, token_b_address, start_date, end_date, token_b_party);\n', '    enterDate = now;\n', '    current_state = SwapState.started;\n', '  }\n', '\n', '  /*\n', '  * This function creates the DRCT tokens for the short and long parties, and ensures the short and long parties\n', '  * have funded the contract with the correct amount of the ERC20 tokens A and B\n', '  *\n', '  */\n', '  function createTokens() public onlyState(SwapState.started){\n', '\n', '    //Ensure the contract has been funded by tokens a and b within 1 day\n', '    require(\n', '      now < (enterDate + 86400) &&\n', '      token_a.balanceOf(address(this)) >= token_a_amount &&\n', '      token_b.balanceOf(address(this)) >= token_b_amount\n', '    );\n', '\n', '    uint tokenratio = 1;\n', '    (long_token_address,tokenratio) = factory.createToken(token_a_amount, long_party,true,start_date);\n', '    num_DRCT_longtokens = token_a_amount.div(tokenratio);\n', '    (short_token_address,tokenratio) = factory.createToken(token_b_amount, short_party,false,start_date);\n', '    num_DRCT_shorttokens = token_b_amount.div(tokenratio);\n', '    current_state = SwapState.tokenized;\n', '    if (premium > 0){\n', '      if (creator == long_party){\n', '      short_party.transfer(premium);\n', '      }\n', '      else {\n', '        long_party.transfer(premium);\n', '      }\n', '    }\n', '  }\n', '\n', '  /*\n', '  * This function calculates the payout of the swap. It can be called after the Swap has been tokenized.\n', '  * The value of the underlying cannot reach zero, but rather can only get within 0.001 * the precision\n', '  * of the Oracle.\n', '  */\n', '  function Calculate() internal {\n', '    require(now >= end_date + 86400);\n', '    //Comment out above for testing purposes\n', '    oracle = Oracle_Interface(oracle_address);\n', '    uint start_value = oracle.RetrieveData(start_date);\n', '    uint end_value = oracle.RetrieveData(end_date);\n', '\n', '    uint ratio;\n', '    if (start_value > 0 && end_value > 0)\n', '      ratio = (end_value).mul(100000).div(start_value);\n', '    else if (end_value > 0)\n', '      ratio = 10e10;\n', '    else if (start_value > 0)\n', '      ratio = 0;\n', '    else\n', '      ratio = 100000;\n', '    if (ratio == 100000) {\n', '      share_long = share_short = ratio;\n', '    } else if (ratio > 100000) {\n', '      share_long = ((ratio).sub(100000)).mul(multiplier).add(100000);\n', '      if (share_long >= 200000)\n', '        share_short = 0;\n', '      else\n', '        share_short = 200000-share_long;\n', '    } else {\n', '      share_short = SafeMath.sub(100000,ratio).mul(multiplier).add(100000);\n', '       if (share_short >= 200000)\n', '        share_long = 0;\n', '      else\n', '        share_long = 200000- share_short;\n', '    }\n', '\n', '    //Calculate the payouts to long and short parties based on the short and long shares\n', '    calculatePayout();\n', '\n', '    current_state = SwapState.ready;\n', '  }\n', '\n', '  /*\n', '  * Calculates the amount paid to the short and long parties per token\n', '  */\n', '  function calculatePayout() internal {\n', '    uint ratio;\n', '    token_a_amount = token_a_amount.mul(995).div(1000);\n', '    token_b_amount = token_b_amount.mul(995).div(1000);\n', '    //If ratio is flat just swap tokens, otherwise pay the winner the entire other token and only pay the other side a portion of the opposite token\n', '    if (share_long == 100000) {\n', '      pay_to_short_a = (token_a_amount).div(num_DRCT_longtokens);\n', '      pay_to_long_b = (token_b_amount).div(num_DRCT_shorttokens);\n', '      pay_to_short_b = 0;\n', '      pay_to_long_a = 0;\n', '    } else if (share_long > 100000) {\n', '      ratio = SafeMath.min(100000, (share_long).sub(100000));\n', '      pay_to_long_b = (token_b_amount).div(num_DRCT_shorttokens);\n', '      pay_to_short_a = (SafeMath.sub(100000,ratio)).mul(token_a_amount).div(num_DRCT_longtokens).div(100000);\n', '      pay_to_long_a = ratio.mul(token_a_amount).div(num_DRCT_longtokens).div(100000);\n', '      pay_to_short_b = 0;\n', '    } else {\n', '      ratio = SafeMath.min(100000, (share_short).sub(100000));\n', '      pay_to_short_a = (token_a_amount).div(num_DRCT_longtokens);\n', '      pay_to_long_b = (SafeMath.sub(100000,ratio)).mul(token_b_amount).div(num_DRCT_shorttokens).div(100000);\n', '      pay_to_short_b = ratio.mul(token_b_amount).div(num_DRCT_shorttokens).div(100000);\n', '      pay_to_long_a = 0;\n', '    }\n', '  }\n', '\n', '  /*\n', '  * This function can be called after the swap is tokenized or after the Calculate function is called.\n', '  * If the Calculate function has not yet been called, this function will call it.\n', '  * The function then pays every token holder of both the long and short DRCT tokens\n', '  */\n', '  function forcePay(uint _begin, uint _end) public returns (bool) {\n', '    //Calls the Calculate function first to calculate short and long shares\n', '    if(current_state == SwapState.tokenized /*&& now > end_date + 86400*/){\n', '      Calculate();\n', '    }\n', '\n', '    //The state at this point should always be SwapState.ready\n', '    require(current_state == SwapState.ready);\n', '\n', '    //Loop through the owners of long and short DRCT tokens and pay them\n', '\n', '    token = DRCT_Token_Interface(long_token_address);\n', '    uint count = token.addressCount(address(this));\n', '    uint loop_count = count < _end ? count : _end;\n', '    //Indexing begins at 1 for DRCT_Token balances\n', '    for(uint i = loop_count-1; i >= _begin ; i--) {\n', '      address long_owner = token.getHolderByIndex(i, address(this));\n', '      uint to_pay_long = token.getBalanceByIndex(i, address(this));\n', '      paySwap(long_owner, to_pay_long, true);\n', '    }\n', '\n', '    token = DRCT_Token_Interface(short_token_address);\n', '    count = token.addressCount(address(this));\n', '    loop_count = count < _end ? count : _end;\n', '    for(uint j = loop_count-1; j >= _begin ; j--) {\n', '      address short_owner = token.getHolderByIndex(j, address(this));\n', '      uint to_pay_short = token.getBalanceByIndex(j, address(this));\n', '      paySwap(short_owner, to_pay_short, false);\n', '    }\n', '\n', '    if (loop_count == count){\n', '        token_a.transfer(factory_address, token_a.balanceOf(address(this)));\n', '        token_b.transfer(factory_address, token_b.balanceOf(address(this)));\n', '        PaidOut(long_token_address, short_token_address);\n', '        current_state = SwapState.ended;\n', '      }\n', '    return true;\n', '  }\n', '\n', '  /*\n', '  * This function pays the receiver an amount determined by the Calculate function\n', '  *\n', '  * @param "_receiver": The recipient of the payout\n', '  * @param "_amount": The amount of token the recipient holds\n', '  * @param "_is_long": Whether or not the reciever holds a long or short token\n', '  */\n', '  function paySwap(address _receiver, uint _amount, bool _is_long) internal {\n', '    if (_is_long) {\n', '      if (pay_to_long_a > 0)\n', '        token_a.transfer(_receiver, _amount.mul(pay_to_long_a));\n', '      if (pay_to_long_b > 0){\n', '        token_b.transfer(_receiver, _amount.mul(pay_to_long_b));\n', '      }\n', '        factory.payToken(_receiver,long_token_address);\n', '    } else {\n', '\n', '      if (pay_to_short_a > 0)\n', '        token_a.transfer(_receiver, _amount.mul(pay_to_short_a));\n', '      if (pay_to_short_b > 0){\n', '        token_b.transfer(_receiver, _amount.mul(pay_to_short_b));\n', '      }\n', '       factory.payToken(_receiver,short_token_address);\n', '    }\n', '  }\n', '\n', '\n', '  /*\n', '  * This function allows both parties to exit. If only the creator has entered the swap, then the swap can be cancelled and the details modified\n', '  * Once two parties enter the swap, the contract is null after cancelled. Once tokenized however, the contract cannot be ended.\n', '  */\n', '  function Exit() public {\n', '   if (current_state == SwapState.open && msg.sender == token_a_party) {\n', '      token_a.transfer(token_a_party, token_a_amount);\n', '      if (premium>0){\n', '        msg.sender.transfer(premium);\n', '      }\n', '      delete token_a_amount;\n', '      delete token_b_amount;\n', '      delete premium;\n', '      current_state = SwapState.created;\n', '    } else if (current_state == SwapState.started && (msg.sender == token_a_party || msg.sender == token_b_party)) {\n', '      if (msg.sender == token_a_party || msg.sender == token_b_party) {\n', '        token_b.transfer(token_b_party, token_b.balanceOf(address(this)));\n', '        token_a.transfer(token_a_party, token_a.balanceOf(address(this)));\n', '        current_state = SwapState.ended;\n', '        if (premium > 0) { creator.transfer(premium);}\n', '      }\n', '    }\n', '  }\n', '}\n', '\n', '\n', '//Swap Deployer Contract-- purpose is to save gas for deployment of Factory contract\n', 'contract Deployer {\n', '  address owner;\n', '  address factory;\n', '\n', '  function Deployer(address _factory) public {\n', '    factory = _factory;\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function newContract(address _party, address user_contract, uint _start_date) public returns (address created) {\n', '    require(msg.sender == factory);\n', '    address new_contract = new TokenToTokenSwap(factory, _party, user_contract, _start_date);\n', '    return new_contract;\n', '  }\n', '\n', '   function setVars(address _factory, address _owner) public {\n', '    require (msg.sender == owner);\n', '    factory = _factory;\n', '    owner = _owner;\n', '  }\n', '}']