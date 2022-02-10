['pragma solidity 0.4.25;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '        return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract INFLIVERC20 {\n', '    function totalSupply() public view returns (uint total_Supply);\n', '    function balanceOf (address who) public view returns (uint256);\n', '    function allowance (address IFVOwner, address spender) public view returns (uint);\n', '    function transferFrom (address from, address to, uint value) public returns (bool ok);\n', '    function approve (address spender, uint value) public returns (bool ok);\n', '    function transfer (address to, uint value) public returns (bool ok);\n', '    event    Transfer (address indexed from, address indexed to, uint value);\n', '    event    Approval (address indexed IFVOwner, address indexed spender, uint value);\n', '}\n', '\n', '\n', 'contract INFLIV is INFLIVERC20 { \n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    string  public constant name        = "INFLIV";                             // Name of the token\n', '    string  public constant symbol      = "IFV";                                // Symbol of token\n', '    uint8   public constant decimals    = 18;\n', '    \n', '    uint    public _totalsupply         = 70000000 * 10 ** 18;                  // 70 million Total Supply\n', '    uint256 maxPublicSale               = 22000000 * 10 ** 18;                  // 22 million Public Sale\n', '                                   \n', '    uint256 public PricePre             = 6000;                                 // 1 Ether = 6000 tokens in Pre-ICO\n', '    uint256 public PriceICO1            = 3800;                                 // 1 Ether = 3800 tokens in ICO Phase 1\n', '    uint256 public PriceICO2            = 2600;                                 // 1 Ether = 2600 tokens in ICO Phase 2\n', '    uint256 public PublicPrice          = 1800;                                 // 1 Ether = 1800 tokens in Public Sale\n', '    uint256 public PreStartTimeStamp;\n', '    uint256 public PreEndTimeStamp;\n', '    uint256 input_token;\n', '    uint256 bonus_token;\n', '    uint256 total_token;\n', '    uint256 ICO1;\n', '    uint256 ICO2;\n', '    uint256 public ETHReceived;                                                 // Total ETH received in the contract\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping(address => uint)) allowed;\n', '    \n', '    address public IFVOwner;                                                    // Owner of this contract\n', '    bool stopped = false;\n', '\n', '    enum CurrentStages {\n', '        NOTSTARTED,\n', '        PRE,\n', '        ICO,\n', '        PAUSED,\n', '        ENDED\n', '    }\n', '    \n', '    CurrentStages public stage;\n', '    \n', '    modifier atStage(CurrentStages _stage) {\n', '        if (stage != _stage)\n', '            // Contract not in expected state\n', '            revert();\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwner() {\n', '        if (msg.sender != IFVOwner) {\n', '            revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    function INFLIV() public {\n', '        IFVOwner            = msg.sender;\n', '        balances[IFVOwner]  = 48000000 * 10 ** 18;                              // 28 million to owner & 20 million to referral bonus\n', '        balances[address(this)] = maxPublicSale;\n', '        stage               = CurrentStages.NOTSTARTED;\n', '        Transfer (0, IFVOwner, balances[IFVOwner]);\n', '    }\n', '  \n', '    function () public payable {\n', '        require(stage != CurrentStages.ENDED);\n', '        require(!stopped && msg.sender != IFVOwner);\n', '            if(stage == CurrentStages.PRE && now <= PreEndTimeStamp) { \n', '                    require (ETHReceived <= 1500 ether);                        // Hardcap\n', '                    ETHReceived     = (ETHReceived).add(msg.value);\n', '                    input_token     = ((msg.value).mul(PricePre)); \n', '                    bonus_token     = ((input_token).mul(50)).div(100);         // 50% bonus in Pre-ICO\n', '                    total_token     = input_token + bonus_token;\n', '                    transferTokens (msg.sender, total_token);\n', '            }\n', '            else if (now <= ICO2) {\n', '                    \n', '                if(now < ICO1)\n', '                {\n', '                    input_token     = (msg.value).mul(PriceICO1);\n', '                    bonus_token     = ((input_token).mul(25)).div(100);         // 25% bonus in ICO Phase 1\n', '                    total_token     = input_token + bonus_token;\n', '                    transferTokens (msg.sender, total_token);\n', '                }   \n', '                else if(now >= ICO1 && now < ICO2)\n', '                {\n', '                    input_token     = (msg.value).mul(PriceICO2);\n', '                    bonus_token     = ((input_token).mul(10)).div(100);         // 10% bonus in ICO Phase 2\n', '                    total_token     = input_token + bonus_token;\n', '                    transferTokens (msg.sender, total_token);\n', '                }\n', '            }\n', '            else\n', '            {\n', '                    input_token     = (msg.value).mul(PublicPrice);\n', '                    transferTokens (msg.sender, input_token);\n', '            }\n', '    }\n', '     \n', '    function start_ICO() public onlyOwner atStage(CurrentStages.NOTSTARTED)\n', '    {\n', '        stage                   = CurrentStages.PRE;\n', '        stopped                 = false;\n', '        balances[address(this)] = maxPublicSale;\n', '        PreStartTimeStamp       = now;\n', '        PreEndTimeStamp         = now + 20 days;\n', '        ICO1                    = PreEndTimeStamp + 20 days;\n', '        ICO2                    = ICO1 + 20 days;\n', '        Transfer (0, address(this), balances[address(this)]);\n', '    }\n', '    \n', '    function PauseICO() external onlyOwner\n', '    {\n', '        stopped = true;\n', '    }\n', '\n', '    function ResumeICO() external onlyOwner\n', '    {\n', '        stopped = false;\n', '    }\n', '   \n', '    function end_ICO() external onlyOwner atStage(CurrentStages.PRE)\n', '    {\n', '        require (now > ICO2);\n', '        stage                       = CurrentStages.ENDED;\n', '        _totalsupply                = (_totalsupply).sub(balances[address(this)]);\n', '        balances[address(this)]     = 0;\n', '        Transfer (address(this), 0 , balances[address(this)]);\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '        require (_to != 0x0);\n', '        require (balances[_from]    >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);\n', '        balances[_from]             = (balances[_from]).sub(_amount);\n', '        allowed[_from][msg.sender]  = (allowed[_from][msg.sender]).sub(_amount);\n', '        balances[_to]               = (balances[_to]).add(_amount);\n', '        Transfer (_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '        require (_to != 0x0);\n', '        require (balances[msg.sender]       >= _amount && _amount >= 0);\n', '        balances[msg.sender]                = (balances[msg.sender]).sub(_amount);\n', '        balances[_to]                       = (balances[_to]).add(_amount);\n', '        Transfer (msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function transferTokens(address _to, uint256 _amount) private returns (bool success) {\n', '        require (_to != 0x0);       \n', '        require (balances[address(this)]    >= _amount && _amount > 0);\n', '        balances[address(this)]             = (balances[address(this)]).sub(_amount);\n', '        balances[_to]                       = (balances[_to]).add(_amount);\n', '        Transfer (address(this), _to, _amount);\n', '        return true;\n', '    }\n', ' \n', '    function withdrawETH() external onlyOwner {\n', '        IFVOwner.transfer(this.balance);\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '        require (_spender != 0x0);\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval (msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '  \n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        require (_owner != 0x0 && _spender !=0x0);\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 total_Supply) {\n', '        total_Supply                = _totalsupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}']