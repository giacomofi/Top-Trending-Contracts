['pragma solidity ^0.4.11;\n', '\n', '// ==== DISCLAIMER ====\n', '//\n', '// ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.\n', '// ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.\n', '// IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.\n', '// YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.\n', '// DON&#39;T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON&#39;T KNOW WHAT YOU ARE DOING.\n', '//\n', '// THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY\n', '// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,\n', '// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,\n', '// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,\n', '// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n', '// ====\n', '//\n', '\n', '/// @author Santiment LLC\n', '/// @title  SAN - santiment token\n', '\n', 'contract Base {\n', '\n', '    function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }\n', '    function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }\n', '\n', '    modifier only(address allowed) {\n', '        if (msg.sender != allowed) throw;\n', '        _;\n', '    }\n', '\n', '\n', '    ///@return True if `_addr` is a contract\n', '    function isContract(address _addr) constant internal returns (bool) {\n', '        if (_addr == 0) return false;\n', '        uint size;\n', '        assembly {\n', '            size := extcodesize(_addr)\n', '        }\n', '        return (size > 0);\n', '    }\n', '\n', '    // *************************************************\n', '    // *          reentrancy handling                  *\n', '    // *************************************************\n', '\n', '    //@dev predefined locks (up to uint bit length, i.e. 256 possible)\n', '    uint constant internal L00 = 2 ** 0;\n', '    uint constant internal L01 = 2 ** 1;\n', '    uint constant internal L02 = 2 ** 2;\n', '    uint constant internal L03 = 2 ** 3;\n', '    uint constant internal L04 = 2 ** 4;\n', '    uint constant internal L05 = 2 ** 5;\n', '\n', '    //prevents reentrancy attacs: specific locks\n', '    uint private bitlocks = 0;\n', '    modifier noReentrancy(uint m) {\n', '        var _locks = bitlocks;\n', '        if (_locks & m > 0) throw;\n', '        bitlocks |= m;\n', '        _;\n', '        bitlocks = _locks;\n', '    }\n', '\n', '    modifier noAnyReentrancy {\n', '        var _locks = bitlocks;\n', '        if (_locks > 0) throw;\n', '        bitlocks = uint(-1);\n', '        _;\n', '        bitlocks = _locks;\n', '    }\n', '\n', '    ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.\n', '    ///     developer should make the caller function reentrant-safe if it use a reentrant function.\n', '    modifier reentrant { _; }\n', '\n', '}\n', '\n', 'contract Owned is Base {\n', '\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) only(owner) {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() only(newOwner) {\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '}\n', '\n', '\n', 'contract ERC20 is Owned {\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function transfer(address _to, uint256 _value) isStartedOnly returns (bool success) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) isStartedOnly returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) isStartedOnly returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '    bool    public isStarted = false;\n', '\n', '    modifier onlyHolder(address holder) {\n', '        if (balanceOf(holder) == 0) throw;\n', '        _;\n', '    }\n', '\n', '    modifier isStartedOnly() {\n', '        if (!isStarted) throw;\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract SubscriptionModule {\n', '    function attachToken(address addr) public ;\n', '}\n', '\n', 'contract SAN is Owned, ERC20 {\n', '\n', '    string public constant name     = "SANtiment network token";\n', '    string public constant symbol   = "SAN";\n', '    uint8  public constant decimals = 18;\n', '\n', '    address CROWDSALE_MINTER = 0xDa2Cf810c5718135247628689D84F94c61B41d6A;\n', '    address public SUBSCRIPTION_MODULE = 0x00000000;\n', '    address public beneficiary;\n', '\n', '    uint public PLATFORM_FEE_PER_10000 = 1; //0.01%\n', '    uint public totalOnDeposit;\n', '    uint public totalInCirculation;\n', '\n', '    ///@dev constructor\n', '    function SAN() {\n', '        beneficiary = owner = msg.sender;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Don&#39;t accept ethers\n', '    // ------------------------------------------------------------------------\n', '    function () {\n', '        throw;\n', '    }\n', '\n', '    //======== SECTION Configuration: Owner only ========\n', '    //\n', '    ///@notice set beneficiary - the account receiving platform fees.\n', '    function setBeneficiary(address newBeneficiary)\n', '    external\n', '    only(owner) {\n', '        beneficiary = newBeneficiary;\n', '    }\n', '\n', '\n', '    ///@notice attach module managing subscriptions. if subModule==0x0, then disables subscription functionality for this token.\n', '    /// detached module can usually manage subscriptions, but all operations changing token balances are disabled.\n', '    function attachSubscriptionModule(SubscriptionModule subModule)\n', '    noAnyReentrancy\n', '    external\n', '    only(owner) {\n', '        SUBSCRIPTION_MODULE = subModule;\n', '        if (address(subModule) > 0) subModule.attachToken(this);\n', '    }\n', '\n', '    ///@notice set platform fee denominated in 1/10000 of SAN token. Thus "1" means 0.01% of SAN token.\n', '    function setPlatformFeePer10000(uint newFee)\n', '    external\n', '    only(owner) {\n', '        require (newFee <= 10000); //formally maximum fee is 100% (completely insane but technically possible)\n', '        PLATFORM_FEE_PER_10000 = newFee;\n', '    }\n', '\n', '\n', '    //======== Interface XRateProvider: a trivial exchange rate provider. Rate is 1:1 and SAN symbol as the code\n', '    //\n', '    ///@dev used as a default XRateProvider (id==0) by subscription module.\n', '    ///@notice returns always 1 because exchange rate of the token to itself is always 1.\n', '    function getRate() returns(uint32 ,uint32) { return (1,1);  }\n', '    function getCode() public returns(string)  { return symbol; }\n', '\n', '\n', '    //==== Interface ERC20ModuleSupport: Subscription, Deposit and Payment Support =====\n', '    ///\n', '    ///@dev used by subscription module to operate on token balances.\n', '    ///@param msg_sender should be an original msg.sender provided to subscription module.\n', '    function _fulfillPreapprovedPayment(address _from, address _to, uint _value, address msg_sender)\n', '    public\n', '    onlyTrusted\n', '    returns(bool success) {\n', '        success = _from != msg_sender && allowed[_from][msg_sender] >= _value;\n', '        if (!success) {\n', '            Payment(_from, _to, _value, _fee(_value), msg_sender, PaymentStatus.APPROVAL_ERROR, 0);\n', '        } else {\n', '            success = _fulfillPayment(_from, _to, _value, 0, msg_sender);\n', '            if (success) {\n', '                allowed[_from][msg_sender] -= _value;\n', '            }\n', '        }\n', '        return success;\n', '    }\n', '\n', '    ///@dev used by subscription module to operate on token balances.\n', '    ///@param msg_sender should be an original msg.sender provided to subscription module.\n', '    function _fulfillPayment(address _from, address _to, uint _value, uint subId, address msg_sender)\n', '    public\n', '    onlyTrusted\n', '    returns (bool success) {\n', '        var fee = _fee(_value);\n', '        assert (fee <= _value); //internal sanity check\n', '        if (balances[_from] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_from] -= _value;\n', '            balances[_to] += _value - fee;\n', '            balances[beneficiary] += fee;\n', '            Payment(_from, _to, _value, fee, msg_sender, PaymentStatus.OK, subId);\n', '            return true;\n', '        } else {\n', '            Payment(_from, _to, _value, fee, msg_sender, PaymentStatus.BALANCE_ERROR, subId);\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function _fee(uint _value) internal constant returns (uint fee) {\n', '        return _value * PLATFORM_FEE_PER_10000 / 10000;\n', '    }\n', '\n', '    ///@notice used by subscription module to re-create token from returning deposit.\n', '    ///@dev a subscription module is responsible to correct deposit management.\n', '    function _mintFromDeposit(address owner, uint amount)\n', '    public\n', '    onlyTrusted {\n', '        balances[owner] += amount;\n', '        totalOnDeposit -= amount;\n', '        totalInCirculation += amount;\n', '    }\n', '\n', '    ///@notice used by subscription module to burn token while creating a new deposit.\n', '    ///@dev a subscription module is responsible to create and maintain the deposit record.\n', '    function _burnForDeposit(address owner, uint amount)\n', '    public\n', '    onlyTrusted\n', '    returns (bool success) {\n', '        if (balances[owner] >= amount) {\n', '            balances[owner] -= amount;\n', '            totalOnDeposit += amount;\n', '            totalInCirculation -= amount;\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    //========= Crowdsale Only ===============\n', '    ///@notice mint new token for given account in crowdsale stage\n', '    ///@dev allowed only if token not started yet and only for registered minter.\n', '    ///@dev tokens are become in circulation after token start.\n', '    function mint(uint amount, address account)\n', '    onlyCrowdsaleMinter\n', '    isNotStartedOnly\n', '    {\n', '        totalSupply += amount;\n', '        balances[account]+=amount;\n', '    }\n', '\n', '    ///@notice start normal operation of the token. No minting is possible after this point.\n', '    function start()\n', '    isNotStartedOnly\n', '    only(owner) {\n', '        totalInCirculation = totalSupply;\n', '        isStarted = true;\n', '    }\n', '\n', '    //========= SECTION: Modifier ===============\n', '\n', '    modifier onlyCrowdsaleMinter() {\n', '        if (msg.sender != CROWDSALE_MINTER) throw;\n', '        _;\n', '    }\n', '\n', '    modifier onlyTrusted() {\n', '        if (msg.sender != SUBSCRIPTION_MODULE) throw;\n', '        _;\n', '    }\n', '\n', '    ///@dev token not started means minting is possible, but usual token operations are not.\n', '    modifier isNotStartedOnly() {\n', '        if (isStarted) throw;\n', '        _;\n', '    }\n', '\n', '    enum PaymentStatus {OK, BALANCE_ERROR, APPROVAL_ERROR}\n', '    ///@notice event issued on any fee based payment (made of failed).\n', '    ///@param subId - related subscription Id if any, or zero otherwise.\n', '    event Payment(address _from, address _to, uint _value, uint _fee, address caller, PaymentStatus status, uint subId);\n', '\n', '}//contract SAN']
['pragma solidity ^0.4.11;\n', '\n', '// ==== DISCLAIMER ====\n', '//\n', '// ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.\n', '// ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.\n', '// IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.\n', '// YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.\n', "// DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.\n", '//\n', '// THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY\n', '// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,\n', '// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,\n', '// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,\n', '// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n', '// ====\n', '//\n', '\n', '/// @author Santiment LLC\n', '/// @title  SAN - santiment token\n', '\n', 'contract Base {\n', '\n', '    function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }\n', '    function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }\n', '\n', '    modifier only(address allowed) {\n', '        if (msg.sender != allowed) throw;\n', '        _;\n', '    }\n', '\n', '\n', '    ///@return True if `_addr` is a contract\n', '    function isContract(address _addr) constant internal returns (bool) {\n', '        if (_addr == 0) return false;\n', '        uint size;\n', '        assembly {\n', '            size := extcodesize(_addr)\n', '        }\n', '        return (size > 0);\n', '    }\n', '\n', '    // *************************************************\n', '    // *          reentrancy handling                  *\n', '    // *************************************************\n', '\n', '    //@dev predefined locks (up to uint bit length, i.e. 256 possible)\n', '    uint constant internal L00 = 2 ** 0;\n', '    uint constant internal L01 = 2 ** 1;\n', '    uint constant internal L02 = 2 ** 2;\n', '    uint constant internal L03 = 2 ** 3;\n', '    uint constant internal L04 = 2 ** 4;\n', '    uint constant internal L05 = 2 ** 5;\n', '\n', '    //prevents reentrancy attacs: specific locks\n', '    uint private bitlocks = 0;\n', '    modifier noReentrancy(uint m) {\n', '        var _locks = bitlocks;\n', '        if (_locks & m > 0) throw;\n', '        bitlocks |= m;\n', '        _;\n', '        bitlocks = _locks;\n', '    }\n', '\n', '    modifier noAnyReentrancy {\n', '        var _locks = bitlocks;\n', '        if (_locks > 0) throw;\n', '        bitlocks = uint(-1);\n', '        _;\n', '        bitlocks = _locks;\n', '    }\n', '\n', '    ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.\n', '    ///     developer should make the caller function reentrant-safe if it use a reentrant function.\n', '    modifier reentrant { _; }\n', '\n', '}\n', '\n', 'contract Owned is Base {\n', '\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) only(owner) {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() only(newOwner) {\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '}\n', '\n', '\n', 'contract ERC20 is Owned {\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function transfer(address _to, uint256 _value) isStartedOnly returns (bool success) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) isStartedOnly returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) isStartedOnly returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '    bool    public isStarted = false;\n', '\n', '    modifier onlyHolder(address holder) {\n', '        if (balanceOf(holder) == 0) throw;\n', '        _;\n', '    }\n', '\n', '    modifier isStartedOnly() {\n', '        if (!isStarted) throw;\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract SubscriptionModule {\n', '    function attachToken(address addr) public ;\n', '}\n', '\n', 'contract SAN is Owned, ERC20 {\n', '\n', '    string public constant name     = "SANtiment network token";\n', '    string public constant symbol   = "SAN";\n', '    uint8  public constant decimals = 18;\n', '\n', '    address CROWDSALE_MINTER = 0xDa2Cf810c5718135247628689D84F94c61B41d6A;\n', '    address public SUBSCRIPTION_MODULE = 0x00000000;\n', '    address public beneficiary;\n', '\n', '    uint public PLATFORM_FEE_PER_10000 = 1; //0.01%\n', '    uint public totalOnDeposit;\n', '    uint public totalInCirculation;\n', '\n', '    ///@dev constructor\n', '    function SAN() {\n', '        beneficiary = owner = msg.sender;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Don't accept ethers\n", '    // ------------------------------------------------------------------------\n', '    function () {\n', '        throw;\n', '    }\n', '\n', '    //======== SECTION Configuration: Owner only ========\n', '    //\n', '    ///@notice set beneficiary - the account receiving platform fees.\n', '    function setBeneficiary(address newBeneficiary)\n', '    external\n', '    only(owner) {\n', '        beneficiary = newBeneficiary;\n', '    }\n', '\n', '\n', '    ///@notice attach module managing subscriptions. if subModule==0x0, then disables subscription functionality for this token.\n', '    /// detached module can usually manage subscriptions, but all operations changing token balances are disabled.\n', '    function attachSubscriptionModule(SubscriptionModule subModule)\n', '    noAnyReentrancy\n', '    external\n', '    only(owner) {\n', '        SUBSCRIPTION_MODULE = subModule;\n', '        if (address(subModule) > 0) subModule.attachToken(this);\n', '    }\n', '\n', '    ///@notice set platform fee denominated in 1/10000 of SAN token. Thus "1" means 0.01% of SAN token.\n', '    function setPlatformFeePer10000(uint newFee)\n', '    external\n', '    only(owner) {\n', '        require (newFee <= 10000); //formally maximum fee is 100% (completely insane but technically possible)\n', '        PLATFORM_FEE_PER_10000 = newFee;\n', '    }\n', '\n', '\n', '    //======== Interface XRateProvider: a trivial exchange rate provider. Rate is 1:1 and SAN symbol as the code\n', '    //\n', '    ///@dev used as a default XRateProvider (id==0) by subscription module.\n', '    ///@notice returns always 1 because exchange rate of the token to itself is always 1.\n', '    function getRate() returns(uint32 ,uint32) { return (1,1);  }\n', '    function getCode() public returns(string)  { return symbol; }\n', '\n', '\n', '    //==== Interface ERC20ModuleSupport: Subscription, Deposit and Payment Support =====\n', '    ///\n', '    ///@dev used by subscription module to operate on token balances.\n', '    ///@param msg_sender should be an original msg.sender provided to subscription module.\n', '    function _fulfillPreapprovedPayment(address _from, address _to, uint _value, address msg_sender)\n', '    public\n', '    onlyTrusted\n', '    returns(bool success) {\n', '        success = _from != msg_sender && allowed[_from][msg_sender] >= _value;\n', '        if (!success) {\n', '            Payment(_from, _to, _value, _fee(_value), msg_sender, PaymentStatus.APPROVAL_ERROR, 0);\n', '        } else {\n', '            success = _fulfillPayment(_from, _to, _value, 0, msg_sender);\n', '            if (success) {\n', '                allowed[_from][msg_sender] -= _value;\n', '            }\n', '        }\n', '        return success;\n', '    }\n', '\n', '    ///@dev used by subscription module to operate on token balances.\n', '    ///@param msg_sender should be an original msg.sender provided to subscription module.\n', '    function _fulfillPayment(address _from, address _to, uint _value, uint subId, address msg_sender)\n', '    public\n', '    onlyTrusted\n', '    returns (bool success) {\n', '        var fee = _fee(_value);\n', '        assert (fee <= _value); //internal sanity check\n', '        if (balances[_from] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_from] -= _value;\n', '            balances[_to] += _value - fee;\n', '            balances[beneficiary] += fee;\n', '            Payment(_from, _to, _value, fee, msg_sender, PaymentStatus.OK, subId);\n', '            return true;\n', '        } else {\n', '            Payment(_from, _to, _value, fee, msg_sender, PaymentStatus.BALANCE_ERROR, subId);\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function _fee(uint _value) internal constant returns (uint fee) {\n', '        return _value * PLATFORM_FEE_PER_10000 / 10000;\n', '    }\n', '\n', '    ///@notice used by subscription module to re-create token from returning deposit.\n', '    ///@dev a subscription module is responsible to correct deposit management.\n', '    function _mintFromDeposit(address owner, uint amount)\n', '    public\n', '    onlyTrusted {\n', '        balances[owner] += amount;\n', '        totalOnDeposit -= amount;\n', '        totalInCirculation += amount;\n', '    }\n', '\n', '    ///@notice used by subscription module to burn token while creating a new deposit.\n', '    ///@dev a subscription module is responsible to create and maintain the deposit record.\n', '    function _burnForDeposit(address owner, uint amount)\n', '    public\n', '    onlyTrusted\n', '    returns (bool success) {\n', '        if (balances[owner] >= amount) {\n', '            balances[owner] -= amount;\n', '            totalOnDeposit += amount;\n', '            totalInCirculation -= amount;\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    //========= Crowdsale Only ===============\n', '    ///@notice mint new token for given account in crowdsale stage\n', '    ///@dev allowed only if token not started yet and only for registered minter.\n', '    ///@dev tokens are become in circulation after token start.\n', '    function mint(uint amount, address account)\n', '    onlyCrowdsaleMinter\n', '    isNotStartedOnly\n', '    {\n', '        totalSupply += amount;\n', '        balances[account]+=amount;\n', '    }\n', '\n', '    ///@notice start normal operation of the token. No minting is possible after this point.\n', '    function start()\n', '    isNotStartedOnly\n', '    only(owner) {\n', '        totalInCirculation = totalSupply;\n', '        isStarted = true;\n', '    }\n', '\n', '    //========= SECTION: Modifier ===============\n', '\n', '    modifier onlyCrowdsaleMinter() {\n', '        if (msg.sender != CROWDSALE_MINTER) throw;\n', '        _;\n', '    }\n', '\n', '    modifier onlyTrusted() {\n', '        if (msg.sender != SUBSCRIPTION_MODULE) throw;\n', '        _;\n', '    }\n', '\n', '    ///@dev token not started means minting is possible, but usual token operations are not.\n', '    modifier isNotStartedOnly() {\n', '        if (isStarted) throw;\n', '        _;\n', '    }\n', '\n', '    enum PaymentStatus {OK, BALANCE_ERROR, APPROVAL_ERROR}\n', '    ///@notice event issued on any fee based payment (made of failed).\n', '    ///@param subId - related subscription Id if any, or zero otherwise.\n', '    event Payment(address _from, address _to, uint _value, uint _fee, address caller, PaymentStatus status, uint subId);\n', '\n', '}//contract SAN']
