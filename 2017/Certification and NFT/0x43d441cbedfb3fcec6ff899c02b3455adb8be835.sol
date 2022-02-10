['//! By Parity Technologies, 2017.\n', '//! Released under the Apache Licence 2.\n', '\n', 'pragma solidity ^0.4.15;\n', '\n', '// ECR20 standard token interface\n', 'contract Token {\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '}\n', '\n', '// Owner-specific contract interface\n', 'contract Owned {\n', '  event NewOwner(address indexed old, address indexed current);\n', '\n', '  modifier only_owner {\n', '    require (msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  address public owner = msg.sender;\n', '\n', '  function setOwner(address _new) only_owner {\n', '    NewOwner(owner, _new);\n', '    owner = _new;\n', '  }\n', '}\n', '\n', '/// Stripped down certifier interface.\n', 'contract Certifier {\n', '  function certified(address _who) constant returns (bool);\n', '}\n', '\n', '// BasicCoin, ECR20 tokens that all belong to the owner for sending around\n', 'contract AmberToken is Token, Owned {\n', '  struct Account {\n', '    // Balance is always less than or equal totalSupply since totalSupply is increased straight away of when releasing locked tokens.\n', '    uint balance;\n', '    mapping (address => uint) allowanceOf;\n', '\n', '    // TokensPerPhase is always less than or equal to totalSupply since anything added to it is UNLOCK_PHASES times lower than added to totalSupply.\n', '    uint tokensPerPhase;\n', '    uint nextPhase;\n', '  }\n', '\n', '  event Minted(address indexed who, uint value);\n', '  event MintedLocked(address indexed who, uint value);\n', '\n', '  function AmberToken() {}\n', '\n', '  // Mint a certain number of tokens.\n', '  // _value has to be bounded not to overflow.\n', '  function mint(address _who, uint _value)\n', '    only_owner\n', '    public\n', '  {\n', '    accounts[_who].balance += _value;\n', '    totalSupply += _value;\n', '    Minted(_who, _value);\n', '  }\n', '\n', '  // Mint a certain number of tokens that are locked up.\n', '  // _value has to be bounded not to overflow.\n', '  function mintLocked(address _who, uint _value)\n', '    only_owner\n', '    public\n', '  {\n', '    accounts[_who].tokensPerPhase += _value / UNLOCK_PHASES;\n', '    totalSupply += _value;\n', '    MintedLocked(_who, _value);\n', '  }\n', '\n', '  /// Finalise any minting operations. Resets the owner and causes normal tokens\n', '  /// to be liquid. Also begins the countdown for locked-up tokens.\n', '  function finalise()\n', '    only_owner\n', '    public\n', '  {\n', '    locked = false;\n', '    owner = 0;\n', '    phaseStart = now;\n', '  }\n', '\n', "  /// Return the current unlock-phase. Won't work until after the contract\n", '  /// has `finalise()` called.\n', '  function currentPhase()\n', '    public\n', '    constant\n', '    returns (uint)\n', '  {\n', '    require (phaseStart > 0);\n', '    uint p = (now - phaseStart) / PHASE_DURATION;\n', '    return p > UNLOCK_PHASES ? UNLOCK_PHASES : p;\n', '  }\n', '\n', '  /// Unlock any now freeable tokens that are locked up for account `_who`.\n', '  function unlockTokens(address _who)\n', '    public\n', '  {\n', '    uint phase = currentPhase();\n', '    uint tokens = accounts[_who].tokensPerPhase;\n', '    uint nextPhase = accounts[_who].nextPhase;\n', '    if (tokens > 0 && phase > nextPhase) {\n', '      accounts[_who].balance += tokens * (phase - nextPhase);\n', '      accounts[_who].nextPhase = phase;\n', '    }\n', '  }\n', '\n', '  // Transfer tokens between accounts.\n', '  function transfer(address _to, uint256 _value)\n', '    when_owns(msg.sender, _value)\n', '    when_liquid\n', '    returns (bool)\n', '  {\n', '    Transfer(msg.sender, _to, _value);\n', '    accounts[msg.sender].balance -= _value;\n', '    accounts[_to].balance += _value;\n', '\n', '    return true;\n', '  }\n', '\n', '  // Transfer via allowance.\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    when_owns(_from, _value)\n', '    when_has_allowance(_from, msg.sender, _value)\n', '    when_liquid\n', '    returns (bool)\n', '  {\n', '    Transfer(_from, _to, _value);\n', '    accounts[_from].allowanceOf[msg.sender] -= _value;\n', '    accounts[_from].balance -= _value;\n', '    accounts[_to].balance += _value;\n', '\n', '    return true;\n', '  }\n', '\n', '  // Approve allowances\n', '  function approve(address _spender, uint256 _value)\n', '    when_liquid\n', '    returns (bool)\n', '  {\n', '    // Mitigate the race condition described here:\n', '    // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require (_value == 0 || accounts[msg.sender].allowanceOf[_spender] == 0);\n', '    Approval(msg.sender, _spender, _value);\n', '    accounts[msg.sender].allowanceOf[_spender] = _value;\n', '\n', '    return true;\n', '  }\n', '\n', '  // Get the balance of a specific address.\n', '  function balanceOf(address _who) constant returns (uint256) {\n', '    return accounts[_who].balance;\n', '  }\n', '\n', '  // Available allowance\n', '  function allowance(address _owner, address _spender)\n', '    constant\n', '    returns (uint256)\n', '  {\n', '    return accounts[_owner].allowanceOf[_spender];\n', '  }\n', '\n', '  // The balance should be available\n', '  modifier when_owns(address _owner, uint _amount) {\n', '    require (accounts[_owner].balance >= _amount);\n', '    _;\n', '  }\n', '\n', '  // An allowance should be available\n', '  modifier when_has_allowance(address _owner, address _spender, uint _amount) {\n', '    require (accounts[_owner].allowanceOf[_spender] >= _amount);\n', '    _;\n', '  }\n', '\n', '  // Tokens must not be locked.\n', '  modifier when_liquid {\n', '    require (!locked);\n', '    _;\n', '  }\n', '\n', '  /// Usual token descriptors.\n', '  string constant public name = "Amber Token";\n', '  uint8 constant public decimals = 18;\n', '  string constant public symbol = "AMB";\n', '\n', '  // Are the tokens non-transferrable?\n', '  bool public locked = true;\n', '\n', '  // Phase information for slow-release tokens.\n', '  uint public phaseStart = 0;\n', '  uint public constant PHASE_DURATION = 180 days;\n', '  uint public constant UNLOCK_PHASES = 4;\n', '\n', '  // available token supply\n', '  uint public totalSupply;\n', '\n', '  // storage and mapping of all balances & allowances\n', '  mapping (address => Account) accounts;\n', '}\n', '\n', '/// Will accept Ether "contributions" and record each both as a log and in a\n', '/// queryable record.\n', 'contract AmbrosusSale {\n', '  /// Constructor.\n', '  function AmbrosusSale() {\n', '    tokens = new AmberToken();\n', '    tokens.mint(0x00C269e9D02188E39C9922386De631c6AED5b4d4, 144590975014280560863612000);\n', '    saleRevenue += 144590975014280560863612000;\n', '    totalSold += 144590975014280560863612000;\n', '\n', '  }\n', '\n', '  // Can only be called by the administrator.\n', '  modifier only_admin { require (msg.sender == ADMINISTRATOR); _; }\n', '  // Can only be called by the prepurchaser.\n', '  modifier only_prepurchaser { require (msg.sender == PREPURCHASER); _; }\n', '\n', '  // The transaction params are valid for buying in.\n', '  modifier is_valid_buyin { require (tx.gasprice <= MAX_BUYIN_GAS_PRICE && msg.value >= MIN_BUYIN_VALUE); _; }\n', '  // Requires the hard cap to be respected given the desired amount for `buyin`.\n', '  modifier is_under_cap_with(uint buyin) { require (buyin + saleRevenue <= MAX_REVENUE); _; }\n', '  // Requires sender to be certified.\n', '  modifier only_certified(address who) { require (CERTIFIER.certified(who)); _; }\n', '\n', '  /*\n', '    Sale life cycle:\n', '    1. Not yet started.\n', '    2. Started, further purchases possible.\n', '      a. Normal operation (next step can be 2b or 3)\n', '      b. Paused (next step can be 2a or 3)\n', '    3. Complete (equivalent to Allocation Lifecycle 2 & 3).\n', '  */\n', '\n', '  // Can only be called by prior to the period (1).\n', '  modifier only_before_period { require (now < BEGIN_TIME); _; }\n', '  // Can only be called during the period when not paused (2a).\n', '  modifier only_during_period { require (now >= BEGIN_TIME && now < END_TIME && !isPaused); _; }\n', '  // Can only be called during the period when paused (2b)\n', '  modifier only_during_paused_period { require (now >= BEGIN_TIME && now < END_TIME && isPaused); _; }\n', '  // Can only be called after the period (3).\n', '  modifier only_after_sale { require (now >= END_TIME || saleRevenue >= MAX_REVENUE); _; }\n', '\n', '  /*\n', '    Allocation life cycle:\n', '    1. Uninitialised (sale not yet started/ended, equivalent to Sale Lifecycle 1 & 2).\n', '    2. Initialised, not yet completed (further allocations possible).\n', '    3. Completed (no further allocations possible).\n', '  */\n', '\n', '  // Only when allocations have not yet been initialised (1).\n', '  modifier when_allocations_uninitialised { require (!allocationsInitialised); _; }\n', '  // Only when sufficient allocations remain for making this liquid allocation (2).\n', '  modifier when_allocatable_liquid(uint amount) { require (liquidAllocatable >= amount); _; }\n', '  // Only when sufficient allocations remain for making this locked allocation (2).\n', '  modifier when_allocatable_locked(uint amount) { require (lockedAllocatable >= amount); _; }\n', '  // Only when no further allocations are possible (3).\n', '  modifier when_allocations_complete { require (allocationsInitialised && liquidAllocatable == 0 && lockedAllocatable == 0); _; }\n', '\n', '  /// Note a pre-ICO sale.\n', '  event Prepurchased(address indexed recipient, uint etherPaid, uint amberSold);\n', '  /// Some contribution `amount` received from `recipient`.\n', '  event Purchased(address indexed recipient, uint amount);\n', '  /// Some contribution `amount` received from `recipient`.\n', '  event SpecialPurchased(address indexed recipient, uint etherPaid, uint amberSold);\n', '  /// Period paused abnormally.\n', '  event Paused();\n', '  /// Period restarted after abnormal halt.\n', '  event Unpaused();\n', '  /// Some contribution `amount` received from `recipient`.\n', '  event Allocated(address indexed recipient, uint amount, bool liquid);\n', '\n', '  /// Note a prepurchase that has already happened.\n', '  /// Up to owner to ensure that values do not overflow.\n', '  ///\n', '  /// Preconditions: !sale_started\n', '  /// Writes {Tokens, Sale}\n', '  function notePrepurchase(address _who, uint _etherPaid, uint _amberSold)\n', '    only_prepurchaser\n', '    only_before_period\n', '    public\n', '  {\n', '    // Admin ensures bounded value.\n', '    tokens.mint(_who, _amberSold);\n', '    saleRevenue += _etherPaid;\n', '    totalSold += _amberSold;\n', '    Prepurchased(_who, _etherPaid, _amberSold);\n', '  }\n', '\n', '  /// Make a purchase from a privileged account. No KYC is required and a\n', '  /// preferential buyin rate may be given.\n', '  ///\n', '  /// Preconditions: !paused, sale_ongoing\n', '  /// Postconditions: !paused, ?!sale_ongoing\n', '  /// Writes {Tokens, Sale}\n', '  function specialPurchase()\n', '    only_before_period\n', '    is_under_cap_with(msg.value)\n', '    payable\n', '    public\n', '  {\n', '    uint256 bought = buyinReturn(msg.sender) * msg.value;\n', "    require (bought > 0);   // be kind and don't punish the idiots.\n", '\n', '    // Bounded value, see STANDARD_BUYIN.\n', '    tokens.mint(msg.sender, bought);\n', '    TREASURY.transfer(msg.value);\n', '    saleRevenue += msg.value;\n', '    totalSold += bought;\n', '    SpecialPurchased(msg.sender, msg.value, bought);\n', '   }\n', '\n', '  /// Let sender make a purchase to their account.\n', '  ///\n', '  /// Preconditions: !paused, sale_ongoing\n', '  /// Postconditions: ?!sale_ongoing\n', '  /// Writes {Tokens, Sale}\n', '  function ()\n', '    only_certified(msg.sender)\n', '    payable\n', '    public\n', '  {\n', '    processPurchase(msg.sender);\n', '  }\n', '\n', '  /// Let sender make a standard purchase; AMB goes into another account.\n', '  ///\n', '  /// Preconditions: !paused, sale_ongoing\n', '  /// Postconditions: ?!sale_ongoing\n', '  /// Writes {Tokens, Sale}\n', '  function purchaseTo(address _recipient)\n', '    only_certified(msg.sender)\n', '    payable\n', '    public\n', '  {\n', '    processPurchase(_recipient);\n', '  }\n', '\n', '  /// Receive a contribution from `_recipient`.\n', '  ///\n', '  /// Preconditions: !paused, sale_ongoing\n', '  /// Postconditions: ?!sale_ongoing\n', '  /// Writes {Tokens, Sale}\n', '  function processPurchase(address _recipient)\n', '    only_during_period\n', '    is_valid_buyin\n', '    is_under_cap_with(msg.value)\n', '    private\n', '  {\n', '    // Bounded value, see STANDARD_BUYIN.\n', '    tokens.mint(_recipient, msg.value * STANDARD_BUYIN);\n', '    TREASURY.transfer(msg.value);\n', '    saleRevenue += msg.value;\n', '    totalSold += msg.value * STANDARD_BUYIN;\n', '    Purchased(_recipient, msg.value);\n', '  }\n', '\n', '  /// Determine purchase price for a given address.\n', '  function buyinReturn(address _who)\n', '    constant\n', '    public\n', '    returns (uint)\n', '  {\n', '    // Chinese exchanges.\n', '    if (\n', '      _who == CHINESE_EXCHANGE_1 || _who == CHINESE_EXCHANGE_2 ||\n', '      _who == CHINESE_EXCHANGE_3 || _who == CHINESE_EXCHANGE_4\n', '    )\n', '      return CHINESE_EXCHANGE_BUYIN;\n', '\n', '    // BTCSuisse tier 1\n', '    if (_who == BTC_SUISSE_TIER_1)\n', '      return STANDARD_BUYIN;\n', '    // BTCSuisse tier 2\n', '    if (_who == BTC_SUISSE_TIER_2)\n', '      return TIER_2_BUYIN;\n', '    // BTCSuisse tier 3\n', '    if (_who == BTC_SUISSE_TIER_3)\n', '      return TIER_3_BUYIN;\n', '    // BTCSuisse tier 4\n', '    if (_who == BTC_SUISSE_TIER_4)\n', '      return TIER_4_BUYIN;\n', '\n', '    return 0;\n', '  }\n', '\n', '  /// Halt the contribution period. Any attempt at contributing will fail.\n', '  ///\n', '  /// Preconditions: !paused, sale_ongoing\n', '  /// Postconditions: paused\n', '  /// Writes {Paused}\n', '  function pause()\n', '    only_admin\n', '    only_during_period\n', '    public\n', '  {\n', '    isPaused = true;\n', '    Paused();\n', '  }\n', '\n', '  /// Unhalt the contribution period.\n', '  ///\n', '  /// Preconditions: paused\n', '  /// Postconditions: !paused\n', '  /// Writes {Paused}\n', '  function unpause()\n', '    only_admin\n', '    only_during_paused_period\n', '    public\n', '  {\n', '    isPaused = false;\n', '    Unpaused();\n', '  }\n', '\n', '  /// Called once by anybody after the sale ends.\n', '  /// Initialises the specific values (i.e. absolute token quantities) of the\n', '  /// allowed liquid/locked allocations.\n', '  ///\n', '  /// Preconditions: !allocations_initialised\n', '  /// Postconditions: allocations_initialised, !allocations_complete\n', '  /// Writes {Allocations}\n', '  function initialiseAllocations()\n', '    public\n', '    only_after_sale\n', '    when_allocations_uninitialised\n', '  {\n', '    allocationsInitialised = true;\n', '    liquidAllocatable = LIQUID_ALLOCATION_PPM * totalSold / SALES_ALLOCATION_PPM;\n', '    lockedAllocatable = LOCKED_ALLOCATION_PPM * totalSold / SALES_ALLOCATION_PPM;\n', '  }\n', '\n', '  /// Preallocate a liquid portion of tokens.\n', '  /// Admin may call this to allocate a share of the liquid tokens.\n', '  /// Up to admin to ensure that value does not overflow.\n', '  ///\n', '  /// Preconditions: allocations_initialised\n', '  /// Postconditions: ?allocations_complete\n', '  /// Writes {Allocations, Tokens}\n', '  function allocateLiquid(address _who, uint _value)\n', '    only_admin\n', '    when_allocatable_liquid(_value)\n', '    public\n', '  {\n', '    // Admin ensures bounded value.\n', '    tokens.mint(_who, _value);\n', '    liquidAllocatable -= _value;\n', '    Allocated(_who, _value, true);\n', '  }\n', '\n', '  /// Preallocate a locked-up portion of tokens.\n', '  /// Admin may call this to allocate a share of the locked tokens.\n', '  /// Up to admin to ensure that value does not overflow and _value is divisible by UNLOCK_PHASES.\n', '  ///\n', '  /// Preconditions: allocations_initialised\n', '  /// Postconditions: ?allocations_complete\n', '  /// Writes {Allocations, Tokens}\n', '  function allocateLocked(address _who, uint _value)\n', '    only_admin\n', '    when_allocatable_locked(_value)\n', '    public\n', '  {\n', '    // Admin ensures bounded value.\n', '    tokens.mintLocked(_who, _value);\n', '    lockedAllocatable -= _value;\n', '    Allocated(_who, _value, false);\n', '  }\n', '\n', '  /// End of the sale and token allocation; retire this contract.\n', '  /// Once called, no more tokens can be minted, basic tokens are now liquid.\n', '  /// Anyone can call, but only once this contract can properly be retired.\n', '  ///\n', '  /// Preconditions: allocations_complete\n', '  /// Postconditions: liquid_tokens_transferable, this_is_dead\n', '  /// Writes {Tokens}\n', '  function finalise()\n', '    when_allocations_complete\n', '    public\n', '  {\n', '    tokens.finalise();\n', '  }\n', '\n', '  //////\n', '  // STATE\n', '  //////\n', '\n', '  // How much is enough?\n', '  uint public constant MIN_BUYIN_VALUE = 10000000000000000;\n', '  // Max gas price for buyins.\n', '  uint public constant MAX_BUYIN_GAS_PRICE = 25000000000;\n', '  // The exposed hard cap.\n', '  uint public constant MAX_REVENUE = 425203 ether;\n', '\n', '  // The total share of tokens, expressed in PPM, allocated to pre-ICO and ICO.\n', '  uint constant public SALES_ALLOCATION_PPM = 400000;\n', '  // The total share of tokens, expressed in PPM, the admin may later allocate, as locked tokens.\n', '  uint constant public LOCKED_ALLOCATION_PPM = 337000;\n', '  // The total share of tokens, expressed in PPM, the admin may later allocate, as liquid tokens.\n', '  uint constant public LIQUID_ALLOCATION_PPM = 263000;\n', '\n', '  /// The certifier resource. TODO: set address\n', '  Certifier public constant CERTIFIER = Certifier(0x7b1Ab331546F021A40bd4D09fFb802261CaACcc9);\n', '  // Who can halt/unhalt/kill?\n', '  address public constant ADMINISTRATOR = 0x00C269e9D02188E39C9922386De631c6AED5b4d4;//0x11bf17b890a80080a8f9c1673d2951296a6f3d91;\n', '  // Who can prepurchase?\n', '  address public constant PREPURCHASER = 0x00D426e9F24E0F426706A1aBf96E375014684C78;\n', '  // Who gets the stash? Should not release funds during minting process.\n', '  address public constant TREASURY = 0x00D426e9F24E0F426706A1aBf96E375014684C78;\n', '  // When does the contribution period begin?\n', '  uint public constant BEGIN_TIME = 1505779200;\n', '  // How long does the sale last for?\n', '  uint public constant DURATION = 30 days;\n', '  // When does the period end?\n', '  uint public constant END_TIME = BEGIN_TIME + DURATION;\n', '\n', '  // The privileged buyin accounts.\n', '  address public constant BTC_SUISSE_TIER_1 = 0x53B3D4f98fcb6f0920096fe1cCCa0E4327Da7a1D;\n', '  address public constant BTC_SUISSE_TIER_2 = 0x642fDd12b1Dd27b9E19758F0AefC072dae7Ab996;\n', '  address public constant BTC_SUISSE_TIER_3 = 0x64175446A1e3459c3E9D650ec26420BA90060d28;\n', '  address public constant BTC_SUISSE_TIER_4 = 0xB17C2f9a057a2640309e41358a22Cf00f8B51626;\n', '  address public constant CHINESE_EXCHANGE_1 = 0x36f548fAB37Fcd39cA8725B8fA214fcd784FE0A3;\n', '  address public constant CHINESE_EXCHANGE_2 = 0x877Da872D223AB3D073Ab6f9B4bb27540E387C5F;\n', '  address public constant CHINESE_EXCHANGE_3 = 0xCcC088ec38A4dbc15Ba269A176883F6ba302eD8d;\n', '  // TODO: set address\n', '  address public constant CHINESE_EXCHANGE_4 = 0;\n', '\n', '  // Tokens per eth for the various buy-in rates.\n', '  // 1e8 ETH in existence, means at most 1.5e11 issued.\n', '  uint public constant STANDARD_BUYIN = 1000;\n', '  uint public constant TIER_2_BUYIN = 1111;\n', '  uint public constant TIER_3_BUYIN = 1250;\n', '  uint public constant TIER_4_BUYIN = 1429;\n', '  uint public constant CHINESE_EXCHANGE_BUYIN = 1087;\n', '\n', '  //////\n', '  // State Subset: Allocations\n', '  //\n', '  // Invariants:\n', '  // !allocationsInitialised ||\n', '  //   (liquidAllocatable + tokens.liquidAllocated) / LIQUID_ALLOCATION_PPM == totalSold / SALES_ALLOCATION_PPM &&\n', '  //   (lockedAllocatable + tokens.lockedAllocated) / LOCKED_ALLOCATION_PPM == totalSold / SALES_ALLOCATION_PPM\n', '  //\n', '  // when_allocations_complete || (now < END_TIME && saleRevenue < MAX_REVENUE)\n', '\n', '  // Have post-sale token allocations been initialised?\n', '  bool public allocationsInitialised = false;\n', '  // How many liquid tokens may yet be allocated?\n', '  uint public liquidAllocatable;\n', '  // How many locked tokens may yet be allocated?\n', '  uint public lockedAllocatable;\n', '\n', '  //////\n', '  // State Subset: Sale\n', '  //\n', '  // Invariants:\n', '  // saleRevenue <= MAX_REVENUE\n', '\n', '  // Total amount raised in both presale and sale, in Wei.\n', '  // Assuming TREASURY locks funds, so can not exceed total amount of Ether 1e8.\n', '  uint public saleRevenue = 0;\n', '  // Total amount minted in both presale and sale, in AMB * 10^-18.\n', '  // Assuming the TREASURY locks funds, msg.value * STANDARD_BUYIN will be less than 1.5e11.\n', '  uint public totalSold = 0;\n', '\n', '  //////\n', '  // State Subset: Tokens\n', '\n', '  // The contract which gets called whenever anything is received.\n', '  AmberToken public tokens;\n', '\n', '  //////\n', '  // State Subset: Pause\n', '\n', '  // Are contributions abnormally paused?\n', '  bool public isPaused = false;\n', '}']