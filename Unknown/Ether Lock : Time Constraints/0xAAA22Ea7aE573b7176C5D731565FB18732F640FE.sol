['pragma solidity ^0.4.11;\n', '\n', 'contract Owned {\n', '\n', '    address public owner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function setOwner(address _newOwner) onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title Prealloc\n', ' * @dev Pre-alloc storage vars, to flatten gas usage in future operations.\n', ' */\n', 'library Prealloc {\n', '    struct UINT256 {\n', '        uint256 value_;\n', '    }\n', '\n', '    function set(UINT256 storage i, uint256 value) internal {\n', '        i.value_ = ~value;\n', '    }\n', '\n', '    function get(UINT256 storage i) internal constant returns (uint256) {\n', '        return ~i.value_;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '\n', '/// VEN token, ERC20 compliant\n', 'contract VEN is Token, Owned {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name    = "VeChain Token";  //The Token&#39;s name\n', '    uint8 public constant decimals = 18;               //Number of decimals of the smallest unit\n', '    string public constant symbol  = "VEN";            //An identifier    \n', '\n', '    struct Account {\n', '        uint256 balance;\n', '        // raw token can be transformed into balance with bonus\n', '        uint256 rawTokens;\n', '    }\n', '\n', '    // Balances for each account\n', '    mapping(address => Account) accounts;\n', '\n', '    // Owner of account approves the transfer of an amount to another account\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    // every buying will update this var. \n', '    // pre-alloc to make first buying cost no much more gas than subsequent\n', '    using Prealloc for Prealloc.UINT256;\n', '    Prealloc.UINT256 rawTokensSupplied;\n', '\n', '    // bonus that can be shared by raw tokens\n', '    uint256 bonusOffered;\n', '\n', '    // Constructor\n', '    function VEN() {\n', '        rawTokensSupplied.set(0);\n', '    }\n', '\n', '    // Send back ether sent to me\n', '    function () {\n', '        revert();\n', '    }\n', '\n', '    // If sealed, transfer is enabled and mint is disabled\n', '    function isSealed() constant returns (bool) {\n', '        return owner == 0;\n', '    }\n', '\n', '    // Claim bonus by raw tokens\n', '    function claimBonus(address _owner) internal{      \n', '        require(isSealed());\n', '        if (accounts[_owner].rawTokens != 0) {\n', '            accounts[_owner].balance = balanceOf(_owner);\n', '            accounts[_owner].rawTokens = 0;\n', '        }\n', '    }\n', '\n', '    // What is the balance of a particular account?\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        if (accounts[_owner].rawTokens == 0)\n', '            return accounts[_owner].balance;\n', '\n', '        if (isSealed()) {\n', '            uint256 bonus = \n', '                 accounts[_owner].rawTokens\n', '                .mul(bonusOffered)\n', '                .div(rawTokensSupplied.get());\n', '\n', '            return accounts[_owner].balance\n', '                    .add(accounts[_owner].rawTokens)\n', '                    .add(bonus);\n', '        }\n', '        \n', '        return accounts[_owner].balance.add(accounts[_owner].rawTokens);\n', '    }\n', '\n', '    // Transfer the balance from owner&#39;s account to another account\n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        require(isSealed());\n', '\n', '        // implicitly claim bonus for both sender and receiver\n', '        claimBonus(msg.sender);\n', '        claimBonus(_to);\n', '\n', '        if (accounts[msg.sender].balance >= _amount\n', '            && _amount > 0\n', '            && accounts[_to].balance + _amount > accounts[_to].balance) {\n', '            accounts[msg.sender].balance -= _amount;\n', '            accounts[_to].balance += _amount;\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Send _value amount of tokens from address _from to address _to\n', '    // The transferFrom method is used for a withdraw workflow, allowing contracts to send\n', '    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge\n', '    // fees in sub-currencies; the command should fail unless the _from account has\n', '    // deliberately authorized the sender of the message via some mechanism; we propose\n', '    // these standardized APIs for approval:\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount\n', '    ) returns (bool success) {\n', '        require(isSealed());\n', '\n', '        // implicitly claim bonus for both sender and receiver\n', '        claimBonus(_from);\n', '        claimBonus(_to);\n', '\n', '        if (accounts[_from].balance >= _amount\n', '            && allowed[_from][msg.sender] >= _amount\n', '            && _amount > 0\n', '            && accounts[_to].balance + _amount > accounts[_to].balance) {\n', '            accounts[_from].balance -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            accounts[_to].balance += _amount;\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        //if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    // Mint tokens and assign to some one\n', '    function mint(address _owner, uint256 _amount, bool _isRaw) onlyOwner{\n', '        if (_isRaw) {\n', '            accounts[_owner].rawTokens = accounts[_owner].rawTokens.add(_amount);\n', '            rawTokensSupplied.set(rawTokensSupplied.get().add(_amount));\n', '        } else {\n', '            accounts[_owner].balance = accounts[_owner].balance.add(_amount);\n', '        }\n', '\n', '        totalSupply = totalSupply.add(_amount);\n', '        Transfer(0, _owner, _amount);\n', '    }\n', '    \n', '    // Offer bonus to raw tokens holder\n', '    function offerBonus(uint256 _bonus) onlyOwner {\n', '        bonusOffered = bonusOffered.add(_bonus);\n', '    }\n', '\n', '    // Set owner to zero address, to disable mint, and enable token transfer\n', '    function seal() onlyOwner {\n', '        setOwner(0);\n', '\n', '        totalSupply = totalSupply.add(bonusOffered);\n', '        Transfer(0, address(-1), bonusOffered);\n', '    }\n', '}\n', '\n', 'contract ApprovalReceiver {\n', '    function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData);\n', '}\n', '\n', '\n', '// Contract to sell and distribute VEN tokens\n', 'contract VENSale is Owned{\n', '\n', '    /// chart of stage transition \n', '    ///\n', '    /// deploy   initialize      startTime                            endTime                 finalize\n', '    ///                              | <-earlyStageLasts-> |             | <- closedStageLasts -> |\n', '    ///  O-----------O---------------O---------------------O-------------O------------------------O------------>\n', '    ///     Created     Initialized           Early             Normal             Closed            Finalized\n', '    enum Stage {\n', '        NotCreated,\n', '        Created,\n', '        Initialized,\n', '        Early,\n', '        Normal,\n', '        Closed,\n', '        Finalized\n', '    }\n', '\n', '    using SafeMath for uint256;\n', '    \n', '    uint256 public constant totalSupply         = (10 ** 9) * (10 ** 18); // 1 billion VEN, decimals set to 18\n', '\n', '    uint256 constant privateSupply              = totalSupply * 9 / 100;  // 9% for private ICO\n', '    uint256 constant commercialPlan             = totalSupply * 23 / 100; // 23% for commercial plan\n', '    uint256 constant reservedForTeam            = totalSupply * 5 / 100;  // 5% for team\n', '    uint256 constant reservedForOperations      = totalSupply * 22 / 100; // 22 for operations\n', '\n', '    // 59%\n', '    uint256 public constant nonPublicSupply     = privateSupply + commercialPlan + reservedForTeam + reservedForOperations;\n', '    // 41%\n', '    uint256 public constant publicSupply = totalSupply - nonPublicSupply;\n', '\n', '    uint256 public officialLimit;\n', '    uint256 public channelsLimit;\n', '\n', '    using Prealloc for Prealloc.UINT256;\n', '    Prealloc.UINT256 officialSold_; // amount of tokens officially sold out\n', '\n', '    uint256 public channelsSold;    // amount of tokens sold out via channels\n', '    \n', '    uint256 constant venPerEth = 3500;  // normal exchange rate\n', '    uint256 constant venPerEthEarlyStage = venPerEth + venPerEth * 15 / 100;  // early stage has 15% reward\n', '   \n', '    VEN ven; // VEN token contract follows ERC20 standard\n', '\n', '    address ethVault; // the account to keep received ether\n', '    address venVault; // the account to keep non-public offered VEN tokens\n', '\n', '    uint public startTime; // time to start sale\n', '    uint public endTime;   // tiem to close sale\n', '    uint public earlyStageLasts; // early bird stage lasts in seconds\n', '\n', '    bool initialized;\n', '    bool finalized;\n', '\n', '    function VENSale() {\n', '        officialSold_.set(0);\n', '    }    \n', '\n', '    /// @notice calculte exchange rate according to current stage\n', '    /// @return exchange rate. zero if not in sale.\n', '    function exchangeRate() constant returns (uint256){\n', '        if (stage() == Stage.Early) {\n', '            return venPerEthEarlyStage;\n', '        }\n', '        if (stage() == Stage.Normal) {\n', '            return venPerEth;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    /// @notice for test purpose\n', '    function blockTime() constant returns (uint) {\n', '        return block.timestamp;\n', '    }\n', '\n', '    /// @notice estimate stage\n', '    /// @return current stage\n', '    function stage() constant returns (Stage) { \n', '        if (finalized) {\n', '            return Stage.Finalized;\n', '        }\n', '\n', '        if (!initialized) {\n', '            // deployed but not initialized\n', '            return Stage.Created;\n', '        }\n', '\n', '        if (blockTime() < startTime) {\n', '            // not started yet\n', '            return Stage.Initialized;\n', '        }\n', '\n', '        if (officialSold_.get().add(channelsSold) >= publicSupply) {\n', '            // all sold out\n', '            return Stage.Closed;\n', '        }\n', '\n', '        if (blockTime() < endTime) {\n', '            // in sale            \n', '            if (blockTime() < startTime.add(earlyStageLasts)) {\n', '                // early bird stage\n', '                return Stage.Early;\n', '            }\n', '            // normal stage\n', '            return Stage.Normal;\n', '        }\n', '\n', '        // closed\n', '        return Stage.Closed;\n', '    }\n', '\n', '    /// @notice entry to buy tokens\n', '    function () payable {        \n', '        buy();\n', '    }\n', '\n', '    /// @notice entry to buy tokens\n', '    function buy() payable {\n', '        require(msg.value >= 0.01 ether);\n', '\n', '        uint256 rate = exchangeRate();\n', '        // here don&#39;t need to check stage. rate is only valid when in sale\n', '        require(rate > 0);\n', '\n', '        uint256 remained = officialLimit.sub(officialSold_.get());\n', '        uint256 requested = msg.value.mul(rate);\n', '        if (requested > remained) {\n', '            //exceed remained\n', '            requested = remained;\n', '        }\n', '\n', '        uint256 ethCost = requested.div(rate);\n', '        if (requested > 0) {\n', '            ven.mint(msg.sender, requested, true);\n', '            // transfer ETH to vault\n', '            ethVault.transfer(ethCost);\n', '\n', '            officialSold_.set(officialSold_.get().add(requested));\n', '            onSold(msg.sender, requested, ethCost);        \n', '        }\n', '\n', '        uint256 toReturn = msg.value.sub(ethCost);\n', '        if(toReturn > 0) {\n', '            // return over payed ETH\n', '            msg.sender.transfer(toReturn);\n', '        }        \n', '    }\n', '\n', '    /// @notice calculate tokens sold officially\n', '    function officialSold() constant returns (uint256) {\n', '        return officialSold_.get();\n', '    }\n', '\n', '    /// @notice manually offer tokens to channels\n', '    function offerToChannels(uint256 _venAmount) onlyOwner {\n', '        Stage stg = stage();\n', '        // since the settlement may be delayed, so it&#39;s allowed in closed stage\n', '        require(stg == Stage.Early || stg == Stage.Normal || stg == Stage.Closed);\n', '\n', '        channelsSold = channelsSold.add(_venAmount);\n', '\n', '        //should not exceed limit\n', '        require(channelsSold <= channelsLimit);\n', '\n', '        ven.mint(\n', '            venVault,\n', '            _venAmount,\n', '            true  // unsold tokens can be claimed by channels portion\n', '            );\n', '\n', '        onSold(venVault, _venAmount, 0);\n', '    }\n', '\n', '    /// @notice initialize to prepare for sale\n', '    /// @param _ven The address VEN token contract following ERC20 standard\n', '    /// @param _ethVault The place to store received ETH\n', '    /// @param _venVault The place to store non-publicly supplied VEN tokens\n', '    /// @param _channelsLimit The hard limit for channels sale\n', '    /// @param _startTime The time when sale starts\n', '    /// @param _endTime The time when sale ends\n', '    /// @param _earlyStageLasts duration of early stage\n', '    function initialize(\n', '        VEN _ven,\n', '        address _ethVault,\n', '        address _venVault,\n', '        uint256 _channelsLimit,\n', '        uint _startTime,\n', '        uint _endTime,\n', '        uint _earlyStageLasts) onlyOwner {\n', '        require(stage() == Stage.Created);\n', '\n', '        // ownership of token contract should already be this\n', '        require(_ven.owner() == address(this));\n', '\n', '        require(address(_ethVault) != 0);\n', '        require(address(_venVault) != 0);\n', '\n', '        require(_startTime > blockTime());\n', '        require(_startTime.add(_earlyStageLasts) < _endTime);        \n', '\n', '        ven = _ven;\n', '        \n', '        ethVault = _ethVault;\n', '        venVault = _venVault;\n', '\n', '        channelsLimit = _channelsLimit;\n', '        officialLimit = publicSupply.sub(_channelsLimit);\n', '\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        earlyStageLasts = _earlyStageLasts;        \n', '        \n', '        ven.mint(\n', '            venVault,\n', '            reservedForTeam.add(reservedForOperations),\n', '            false // team and operations reserved portion can&#39;t share unsold tokens\n', '        );\n', '\n', '        ven.mint(\n', '            venVault,\n', '            privateSupply.add(commercialPlan),\n', '            true // private ICO and commercial plan can share unsold tokens\n', '        );\n', '\n', '        initialized = true;\n', '        onInitialized();\n', '    }\n', '\n', '    /// @notice finalize\n', '    function finalize() onlyOwner {\n', '        // only after closed stage\n', '        require(stage() == Stage.Closed);       \n', '\n', '        uint256 unsold = publicSupply.sub(officialSold_.get()).sub(channelsSold);\n', '\n', '        if (unsold > 0) {\n', '            // unsold VEN as bonus\n', '            ven.offerBonus(unsold);        \n', '        }\n', '        ven.seal();\n', '\n', '        finalized = true;\n', '        onFinalized();\n', '    }\n', '\n', '    event onInitialized();\n', '    event onFinalized();\n', '\n', '    event onSold(address indexed buyer, uint256 venAmount, uint256 ethCost);\n', '}']