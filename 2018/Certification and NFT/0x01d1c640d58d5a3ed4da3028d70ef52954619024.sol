['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() public {\n', '        owner =  msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract RefundVault is Ownable {\n', '    using SafeMath for uint256;\n', '    enum State { Active, Refunding, Closed }\n', '    mapping (address => uint256) public deposited;\n', '    address public wallet;\n', '    State public state;\n', '    event Closed();\n', '    event RefundsEnabled();\n', '    event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '    function RefundVault(address _wallet) public {\n', '        wallet = _wallet;\n', '        state = State.Active;\n', '    }\n', '    function deposit(address investor) onlyOwner public payable {\n', '        require(state == State.Active);\n', '        deposited[investor] = deposited[investor].add(msg.value);\n', '    }\n', '    function close() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Closed;\n', '        wallet.transfer(this.balance);\n', '        Closed();\n', '    }\n', '    function enableRefunds() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Refunding;\n', '        RefundsEnabled();\n', '    }\n', '    function refund(address investor) public {\n', '        require(state == State.Refunding);\n', '        uint256 depositedValue = deposited[investor];\n', '        deposited[investor] = 0;\n', '        investor.transfer(depositedValue);\n', '        Refunded(investor, depositedValue);\n', '    }\n', '}\n', '\n', 'contract Gryphon is ERC20, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    RefundVault public vault;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => uint256) vested;\n', '    mapping(address => uint256) total_vested;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    string public name = &#39;Gryphon&#39;;\n', '    string public symbol = &#39;GXC&#39;;\n', '    uint256 public decimals = 4;\n', '    uint256 public initialSupply = 2000000000;\n', '\n', '    uint256 public start;\n', '    uint256 public duration;\n', '\n', '    uint256 public rateICO = 910000000000000;\n', '\n', '    uint256 public preSaleMaxCapInWei = 2500 ether;\n', '    uint256 public preSaleRaised = 0;\n', '\n', '    uint256 public icoSoftCapInWei = 2500 ether;\n', '    uint256 public icoHardCapInWei = 122400 ether;\n', '    uint256 public icoRaised = 0;\n', '\n', '    uint256 public presaleStartTimestamp;\n', '    uint256 public presaleEndTimestamp;\n', '    uint256 public icoStartTimestamp;\n', '    uint256 public icoEndTimestamp;\n', '\n', '    uint256 public presaleTokenLimit;\n', '    uint256 public icoTokenLimit;\n', '\n', '    uint256 public investorCount;\n', '\n', '    enum State {Unknown, Preparing, PreSale, ICO, Success, Failure, PresaleFinalized, ICOFinalized}\n', '\n', '    State public crowdSaleState;\n', '\n', '    modifier nonZero() {\n', '        require(msg.value > 0);\n', '        _;\n', '    }\n', '\n', '    function Gryphon() public {\n', '\n', '        owner = 0xf42B82D02b8f3E7983b3f7E1000cE28EC3F8C815;\n', '        vault = new RefundVault(0x6cD6B03D16E4BE08159412a7E290F1EA23446Bf2);\n', '\n', '        totalSupply_ = initialSupply*(10**decimals);\n', '\n', '        balances[owner] = totalSupply_;\n', '\n', '        presaleStartTimestamp = 1523232000;\n', '        presaleEndTimestamp = presaleStartTimestamp + 50 * 1 days;\n', '\n', '        icoStartTimestamp = presaleEndTimestamp + 1 days;\n', '        icoEndTimestamp = icoStartTimestamp + 60 * 1 days;\n', '\n', '        crowdSaleState = State.Preparing;\n', '\n', '        start = 1523232000;\n', '        duration = 23328000;\n', '    }\n', '\n', '    function () nonZero payable {\n', '        enter();\n', '    }\n', '\n', '    function enter() public nonZero payable {\n', '        if(isPreSalePeriod()) {\n', '\n', '            if(crowdSaleState == State.Preparing) {\n', '                crowdSaleState = State.PreSale;\n', '            }\n', '\n', '            buyTokens(msg.sender, msg.value);\n', '        }\n', '        else if (isICOPeriod()) {\n', '            if(crowdSaleState == State.PresaleFinalized) {\n', '                crowdSaleState = State.ICO;\n', '            }\n', '\n', '            buyTokens(msg.sender, msg.value);\n', '        } else {\n', '\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function buyTokens(address _recipient, uint256 _value) internal nonZero returns (bool success) {\n', '        uint256 boughtTokens = calculateTokens(_value);\n', '        require(boughtTokens != 0);\n', '        boughtTokens = boughtTokens*(10**decimals);\n', '\n', '        if(balanceOf(_recipient) == 0) {\n', '            investorCount++;\n', '        }\n', '\n', '        if(isCrowdSaleStatePreSale()) {\n', '            transferTokens(_recipient, boughtTokens);\n', '            vault.deposit.value(_value)(_recipient);\n', '            preSaleRaised = preSaleRaised.add(_value);\n', '            return true;\n', '        } else if (isCrowdSaleStateICO()) {\n', '            transferTokens(_recipient, boughtTokens);\n', '            vault.deposit.value(_value)(_recipient);\n', '            icoRaised = icoRaised.add(_value);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function transferTokens(address _recipient, uint256 tokens_in_cents) internal returns (bool) {\n', '        require(\n', '            tokens_in_cents > 0\n', '            && _recipient != owner\n', '            && tokens_in_cents < balances[owner]\n', '        );\n', '\n', '        balances[owner] = balances[owner].sub(tokens_in_cents);\n', '\n', '        balances[_recipient] = balances[_recipient].add(tokens_in_cents);\n', '        getVested(_recipient);\n', '\n', '        Transfer(owner, _recipient, tokens_in_cents);\n', '        return true;\n', '    }\n', '\n', '    function getVested(address _beneficiary) public returns (uint256) {\n', '        require(balances[_beneficiary]>0);\n', '        if (_beneficiary == owner){\n', '\n', '            vested[owner] = balances[owner];\n', '            total_vested[owner] = balances[owner];\n', '\n', '        } else if (block.timestamp < start) {\n', '\n', '            vested[_beneficiary] = 0;\n', '            total_vested[_beneficiary] = 0;\n', '\n', '        } else if (block.timestamp >= start.add(duration)) {\n', '\n', '            total_vested[_beneficiary] = balances[_beneficiary];\n', '            vested[_beneficiary] = balances[_beneficiary];\n', '\n', '        } else {\n', '\n', '            uint vested_now = balances[_beneficiary].mul(block.timestamp.sub(start)).div(duration);\n', '            if(total_vested[_beneficiary]==0){\n', '                total_vested[_beneficiary] = vested_now;\n', '\n', '            }\n', '            if(vested_now > total_vested[_beneficiary]){\n', '                vested[_beneficiary] = vested[_beneficiary].add(vested_now.sub(total_vested[_beneficiary]));\n', '                total_vested[_beneficiary] = vested_now;\n', '            }\n', '        }\n', '        return vested[_beneficiary];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _tokens_in_cents) public returns (bool) {\n', '        require(_tokens_in_cents > 0);\n', '        require(_to != msg.sender);\n', '        getVested(msg.sender);\n', '        require(balances[msg.sender] >= _tokens_in_cents);\n', '        require(vested[msg.sender] >= _tokens_in_cents);\n', '\n', '        if(balanceOf(_to) == 0) {\n', '            investorCount++;\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_tokens_in_cents);\n', '        vested[msg.sender] = vested[msg.sender].sub(_tokens_in_cents);\n', '        balances[_to] = balances[_to].add(_tokens_in_cents);\n', '\n', '        if(balanceOf(msg.sender) == 0) {\n', '            investorCount=investorCount-1;\n', '        }\n', '\n', '        Transfer(msg.sender, _to, _tokens_in_cents);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _tokens_in_cents) public returns (bool success) {\n', '        require(_tokens_in_cents > 0);\n', '        require(_from != _to);\n', '        getVested(_from);\n', '        require(balances[_from] >= _tokens_in_cents);\n', '        require(vested[_from] >= _tokens_in_cents);\n', '        require(allowed[_from][msg.sender] >= _tokens_in_cents);\n', '\n', '        if(balanceOf(_to) == 0) {\n', '            investorCount++;\n', '        }\n', '\n', '        balances[_from] = balances[_from].sub(_tokens_in_cents);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_tokens_in_cents);\n', '        vested[_from] = vested[_from].sub(_tokens_in_cents);\n', '\n', '        balances[_to] = balances[_to].add(_tokens_in_cents);\n', '\n', '        if(balanceOf(_from) == 0) {\n', '            investorCount=investorCount-1;\n', '        }\n', '\n', '        Transfer(_from, _to, _tokens_in_cents);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _tokens_in_cents) returns (bool success) {\n', '        require(vested[msg.sender] >= _tokens_in_cents);\n', '        allowed[msg.sender][_spender] = _tokens_in_cents;\n', '        Approval(msg.sender, _spender, _tokens_in_cents);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function calculateTokens(uint256 _amount) internal returns (uint256 tokens){\n', '        if(crowdSaleState == State.Preparing && isPreSalePeriod()) {\n', '            crowdSaleState = State.PreSale;\n', '        }\n', '        if(isCrowdSaleStatePreSale()) {\n', '            tokens = _amount.div(rateICO);\n', '        } else if (isCrowdSaleStateICO()) {\n', '            tokens = _amount.div(rateICO);\n', '        } else {\n', '            tokens = 0;\n', '        }\n', '    }\n', '\n', '    function getRefund(address _recipient) public returns (bool){\n', '        require(crowdSaleState == State.Failure);\n', '        require(refundedAmount(_recipient));\n', '        vault.refund(_recipient);\n', '        return true;\n', '    }\n', '\n', '    function refundedAmount(address _recipient) internal returns (bool) {\n', '        require(balances[_recipient] != 0);\n', '        balances[_recipient] = 0;\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(address a) public view returns (uint256 balance) {\n', '        return balances[a];\n', '    }\n', '\n', '    function isCrowdSaleStatePreSale() public constant returns (bool) {\n', '        return crowdSaleState == State.PreSale;\n', '    }\n', '\n', '    function isCrowdSaleStateICO() public constant returns (bool) {\n', '        return crowdSaleState == State.ICO;\n', '    }\n', '\n', '    function isPreSalePeriod() public constant returns (bool) {\n', '        if(preSaleRaised > preSaleMaxCapInWei || now >= presaleEndTimestamp) {\n', '            crowdSaleState = State.PresaleFinalized;\n', '            return false;\n', '        } else {\n', '            return now > presaleStartTimestamp;\n', '        }\n', '    }\n', '\n', '    function isICOPeriod() public constant returns (bool) {\n', '        if (icoRaised > icoHardCapInWei || now >= icoEndTimestamp){\n', '            crowdSaleState = State.ICOFinalized;\n', '            return false;\n', '        } else {\n', '            return now > icoStartTimestamp;\n', '        }\n', '    }\n', '\n', '    function endCrowdSale() public onlyOwner {\n', '        require(now >= icoEndTimestamp || icoRaised >= icoSoftCapInWei);\n', '        if(icoRaised >= icoSoftCapInWei){\n', '            crowdSaleState = State.Success;\n', '            vault.close();\n', '        } else {\n', '            crowdSaleState = State.Failure;\n', '            vault.enableRefunds();\n', '        }\n', '    }\n', '\n', '\n', '    function getInvestorCount() public constant returns (uint256) {\n', '        return investorCount;\n', '    }\n', '\n', '    function getPresaleRaisedAmount() public constant returns (uint256) {\n', '        return preSaleRaised;\n', '    }\n', '\n', '    function getICORaisedAmount() public constant returns (uint256) {\n', '        return icoRaised;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() constant returns (uint256 supply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() public {\n', '        owner =  msg.sender;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract RefundVault is Ownable {\n', '    using SafeMath for uint256;\n', '    enum State { Active, Refunding, Closed }\n', '    mapping (address => uint256) public deposited;\n', '    address public wallet;\n', '    State public state;\n', '    event Closed();\n', '    event RefundsEnabled();\n', '    event Refunded(address indexed beneficiary, uint256 weiAmount);\n', '    function RefundVault(address _wallet) public {\n', '        wallet = _wallet;\n', '        state = State.Active;\n', '    }\n', '    function deposit(address investor) onlyOwner public payable {\n', '        require(state == State.Active);\n', '        deposited[investor] = deposited[investor].add(msg.value);\n', '    }\n', '    function close() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Closed;\n', '        wallet.transfer(this.balance);\n', '        Closed();\n', '    }\n', '    function enableRefunds() onlyOwner public {\n', '        require(state == State.Active);\n', '        state = State.Refunding;\n', '        RefundsEnabled();\n', '    }\n', '    function refund(address investor) public {\n', '        require(state == State.Refunding);\n', '        uint256 depositedValue = deposited[investor];\n', '        deposited[investor] = 0;\n', '        investor.transfer(depositedValue);\n', '        Refunded(investor, depositedValue);\n', '    }\n', '}\n', '\n', 'contract Gryphon is ERC20, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    RefundVault public vault;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => uint256) vested;\n', '    mapping(address => uint256) total_vested;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 totalSupply_;\n', '\n', "    string public name = 'Gryphon';\n", "    string public symbol = 'GXC';\n", '    uint256 public decimals = 4;\n', '    uint256 public initialSupply = 2000000000;\n', '\n', '    uint256 public start;\n', '    uint256 public duration;\n', '\n', '    uint256 public rateICO = 910000000000000;\n', '\n', '    uint256 public preSaleMaxCapInWei = 2500 ether;\n', '    uint256 public preSaleRaised = 0;\n', '\n', '    uint256 public icoSoftCapInWei = 2500 ether;\n', '    uint256 public icoHardCapInWei = 122400 ether;\n', '    uint256 public icoRaised = 0;\n', '\n', '    uint256 public presaleStartTimestamp;\n', '    uint256 public presaleEndTimestamp;\n', '    uint256 public icoStartTimestamp;\n', '    uint256 public icoEndTimestamp;\n', '\n', '    uint256 public presaleTokenLimit;\n', '    uint256 public icoTokenLimit;\n', '\n', '    uint256 public investorCount;\n', '\n', '    enum State {Unknown, Preparing, PreSale, ICO, Success, Failure, PresaleFinalized, ICOFinalized}\n', '\n', '    State public crowdSaleState;\n', '\n', '    modifier nonZero() {\n', '        require(msg.value > 0);\n', '        _;\n', '    }\n', '\n', '    function Gryphon() public {\n', '\n', '        owner = 0xf42B82D02b8f3E7983b3f7E1000cE28EC3F8C815;\n', '        vault = new RefundVault(0x6cD6B03D16E4BE08159412a7E290F1EA23446Bf2);\n', '\n', '        totalSupply_ = initialSupply*(10**decimals);\n', '\n', '        balances[owner] = totalSupply_;\n', '\n', '        presaleStartTimestamp = 1523232000;\n', '        presaleEndTimestamp = presaleStartTimestamp + 50 * 1 days;\n', '\n', '        icoStartTimestamp = presaleEndTimestamp + 1 days;\n', '        icoEndTimestamp = icoStartTimestamp + 60 * 1 days;\n', '\n', '        crowdSaleState = State.Preparing;\n', '\n', '        start = 1523232000;\n', '        duration = 23328000;\n', '    }\n', '\n', '    function () nonZero payable {\n', '        enter();\n', '    }\n', '\n', '    function enter() public nonZero payable {\n', '        if(isPreSalePeriod()) {\n', '\n', '            if(crowdSaleState == State.Preparing) {\n', '                crowdSaleState = State.PreSale;\n', '            }\n', '\n', '            buyTokens(msg.sender, msg.value);\n', '        }\n', '        else if (isICOPeriod()) {\n', '            if(crowdSaleState == State.PresaleFinalized) {\n', '                crowdSaleState = State.ICO;\n', '            }\n', '\n', '            buyTokens(msg.sender, msg.value);\n', '        } else {\n', '\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function buyTokens(address _recipient, uint256 _value) internal nonZero returns (bool success) {\n', '        uint256 boughtTokens = calculateTokens(_value);\n', '        require(boughtTokens != 0);\n', '        boughtTokens = boughtTokens*(10**decimals);\n', '\n', '        if(balanceOf(_recipient) == 0) {\n', '            investorCount++;\n', '        }\n', '\n', '        if(isCrowdSaleStatePreSale()) {\n', '            transferTokens(_recipient, boughtTokens);\n', '            vault.deposit.value(_value)(_recipient);\n', '            preSaleRaised = preSaleRaised.add(_value);\n', '            return true;\n', '        } else if (isCrowdSaleStateICO()) {\n', '            transferTokens(_recipient, boughtTokens);\n', '            vault.deposit.value(_value)(_recipient);\n', '            icoRaised = icoRaised.add(_value);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    function transferTokens(address _recipient, uint256 tokens_in_cents) internal returns (bool) {\n', '        require(\n', '            tokens_in_cents > 0\n', '            && _recipient != owner\n', '            && tokens_in_cents < balances[owner]\n', '        );\n', '\n', '        balances[owner] = balances[owner].sub(tokens_in_cents);\n', '\n', '        balances[_recipient] = balances[_recipient].add(tokens_in_cents);\n', '        getVested(_recipient);\n', '\n', '        Transfer(owner, _recipient, tokens_in_cents);\n', '        return true;\n', '    }\n', '\n', '    function getVested(address _beneficiary) public returns (uint256) {\n', '        require(balances[_beneficiary]>0);\n', '        if (_beneficiary == owner){\n', '\n', '            vested[owner] = balances[owner];\n', '            total_vested[owner] = balances[owner];\n', '\n', '        } else if (block.timestamp < start) {\n', '\n', '            vested[_beneficiary] = 0;\n', '            total_vested[_beneficiary] = 0;\n', '\n', '        } else if (block.timestamp >= start.add(duration)) {\n', '\n', '            total_vested[_beneficiary] = balances[_beneficiary];\n', '            vested[_beneficiary] = balances[_beneficiary];\n', '\n', '        } else {\n', '\n', '            uint vested_now = balances[_beneficiary].mul(block.timestamp.sub(start)).div(duration);\n', '            if(total_vested[_beneficiary]==0){\n', '                total_vested[_beneficiary] = vested_now;\n', '\n', '            }\n', '            if(vested_now > total_vested[_beneficiary]){\n', '                vested[_beneficiary] = vested[_beneficiary].add(vested_now.sub(total_vested[_beneficiary]));\n', '                total_vested[_beneficiary] = vested_now;\n', '            }\n', '        }\n', '        return vested[_beneficiary];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _tokens_in_cents) public returns (bool) {\n', '        require(_tokens_in_cents > 0);\n', '        require(_to != msg.sender);\n', '        getVested(msg.sender);\n', '        require(balances[msg.sender] >= _tokens_in_cents);\n', '        require(vested[msg.sender] >= _tokens_in_cents);\n', '\n', '        if(balanceOf(_to) == 0) {\n', '            investorCount++;\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_tokens_in_cents);\n', '        vested[msg.sender] = vested[msg.sender].sub(_tokens_in_cents);\n', '        balances[_to] = balances[_to].add(_tokens_in_cents);\n', '\n', '        if(balanceOf(msg.sender) == 0) {\n', '            investorCount=investorCount-1;\n', '        }\n', '\n', '        Transfer(msg.sender, _to, _tokens_in_cents);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _tokens_in_cents) public returns (bool success) {\n', '        require(_tokens_in_cents > 0);\n', '        require(_from != _to);\n', '        getVested(_from);\n', '        require(balances[_from] >= _tokens_in_cents);\n', '        require(vested[_from] >= _tokens_in_cents);\n', '        require(allowed[_from][msg.sender] >= _tokens_in_cents);\n', '\n', '        if(balanceOf(_to) == 0) {\n', '            investorCount++;\n', '        }\n', '\n', '        balances[_from] = balances[_from].sub(_tokens_in_cents);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_tokens_in_cents);\n', '        vested[_from] = vested[_from].sub(_tokens_in_cents);\n', '\n', '        balances[_to] = balances[_to].add(_tokens_in_cents);\n', '\n', '        if(balanceOf(_from) == 0) {\n', '            investorCount=investorCount-1;\n', '        }\n', '\n', '        Transfer(_from, _to, _tokens_in_cents);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _tokens_in_cents) returns (bool success) {\n', '        require(vested[msg.sender] >= _tokens_in_cents);\n', '        allowed[msg.sender][_spender] = _tokens_in_cents;\n', '        Approval(msg.sender, _spender, _tokens_in_cents);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function calculateTokens(uint256 _amount) internal returns (uint256 tokens){\n', '        if(crowdSaleState == State.Preparing && isPreSalePeriod()) {\n', '            crowdSaleState = State.PreSale;\n', '        }\n', '        if(isCrowdSaleStatePreSale()) {\n', '            tokens = _amount.div(rateICO);\n', '        } else if (isCrowdSaleStateICO()) {\n', '            tokens = _amount.div(rateICO);\n', '        } else {\n', '            tokens = 0;\n', '        }\n', '    }\n', '\n', '    function getRefund(address _recipient) public returns (bool){\n', '        require(crowdSaleState == State.Failure);\n', '        require(refundedAmount(_recipient));\n', '        vault.refund(_recipient);\n', '        return true;\n', '    }\n', '\n', '    function refundedAmount(address _recipient) internal returns (bool) {\n', '        require(balances[_recipient] != 0);\n', '        balances[_recipient] = 0;\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function balanceOf(address a) public view returns (uint256 balance) {\n', '        return balances[a];\n', '    }\n', '\n', '    function isCrowdSaleStatePreSale() public constant returns (bool) {\n', '        return crowdSaleState == State.PreSale;\n', '    }\n', '\n', '    function isCrowdSaleStateICO() public constant returns (bool) {\n', '        return crowdSaleState == State.ICO;\n', '    }\n', '\n', '    function isPreSalePeriod() public constant returns (bool) {\n', '        if(preSaleRaised > preSaleMaxCapInWei || now >= presaleEndTimestamp) {\n', '            crowdSaleState = State.PresaleFinalized;\n', '            return false;\n', '        } else {\n', '            return now > presaleStartTimestamp;\n', '        }\n', '    }\n', '\n', '    function isICOPeriod() public constant returns (bool) {\n', '        if (icoRaised > icoHardCapInWei || now >= icoEndTimestamp){\n', '            crowdSaleState = State.ICOFinalized;\n', '            return false;\n', '        } else {\n', '            return now > icoStartTimestamp;\n', '        }\n', '    }\n', '\n', '    function endCrowdSale() public onlyOwner {\n', '        require(now >= icoEndTimestamp || icoRaised >= icoSoftCapInWei);\n', '        if(icoRaised >= icoSoftCapInWei){\n', '            crowdSaleState = State.Success;\n', '            vault.close();\n', '        } else {\n', '            crowdSaleState = State.Failure;\n', '            vault.enableRefunds();\n', '        }\n', '    }\n', '\n', '\n', '    function getInvestorCount() public constant returns (uint256) {\n', '        return investorCount;\n', '    }\n', '\n', '    function getPresaleRaisedAmount() public constant returns (uint256) {\n', '        return preSaleRaised;\n', '    }\n', '\n', '    function getICORaisedAmount() public constant returns (uint256) {\n', '        return icoRaised;\n', '    }\n', '\n', '}']