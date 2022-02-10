['pragma solidity ^0.4.24;\n', '\n', 'library Math {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if(a == 0) { return 0; }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    \n', '    address public owner_;\n', '    mapping(address => bool) locked_;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public { owner_ = msg.sender; }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner_);\n', '        _;\n', '    }\n', '\n', '    modifier locked() {\n', '        require(!locked_[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner_, newOwner);\n', '        owner_ = newOwner;\n', '    }\n', '\n', '    function lock(address owner) public onlyOwner {\n', '        locked_[owner] = true;\n', '    }\n', '\n', '    function unlock(address owner) public onlyOwner {\n', '        locked_[owner] = false;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Token {\n', '    \n', '    using Math for uint256;\n', '    \n', '    event Burn(address indexed burner, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    uint256 totalSupply_;\n', '    mapping(address => uint256) balances_;\n', '    mapping (address => mapping (address => uint256)) internal allowed_;\n', '\n', '    function totalSupply() public view returns (uint256) { return totalSupply_; }\n', '\n', '    function transfer(address to, uint256 value) public returns (bool) {\n', '        require(to != address(0));\n', '        require(value <= balances_[msg.sender]);\n', '\n', '        balances_[msg.sender] = balances_[msg.sender].sub(value);\n', '        balances_[to] = balances_[to].add(value);\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address owner) public view returns (uint256 balance) { return balances_[owner]; }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool) {\n', '        require(to != address(0));\n', '        require(value <= balances_[from]);\n', '        require(value <= allowed_[from][msg.sender]);\n', '\n', '        balances_[from] = balances_[from].sub(value);\n', '        balances_[to] = balances_[to].add(value);\n', '        allowed_[from][msg.sender] = allowed_[from][msg.sender].sub(value);\n', '        emit Transfer(from, to, value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint256 value) public returns (bool) {\n', '        allowed_[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view returns (uint256) {\n', '        return allowed_[owner][spender];\n', '    }\n', '\n', '    function burn(uint256 value) public {\n', '        require(value <= balances_[msg.sender]);\n', '        address burner = msg.sender;\n', '        balances_[burner] = balances_[burner].sub(value);\n', '        totalSupply_ = totalSupply_.sub(value);\n', '        emit Burn(burner, value);\n', '    }    \n', '}\n', '\n', 'contract Baroin is Ownable, ERC20Token {\n', '\n', '    using Math for uint;\n', '\n', '    uint8 constant public decimals  = 18;\n', '    string constant public symbol   = "BRI";\n', '    string constant public name     = "Baroin";\n', '    \n', '    address constant company = 0xE033e897Cae73646753bF5160C2eb1020FA02532;\n', '    \n', '    constructor(uint amount) public {\n', '        totalSupply_ = amount;\n', '        initSetting(company, totalSupply_);\n', '    }\n', '\n', '    function withdrawTokens(address cont) external onlyOwner {\n', '        Baroin tc = Baroin(cont);\n', '        tc.transfer(owner_, tc.balanceOf(this));\n', '    }\n', '\n', '    function initSetting(address addr, uint amount) internal returns (bool) {\n', '        balances_[addr] = amount;\n', '        emit Transfer(address(0x0), addr, amount);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address to, uint256 value) public locked returns (bool) {\n', '        return super.transfer(to, value);\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint256 value) public locked returns (bool) {\n', '        return super.transferFrom(from, to, value);\n', '    }\n', '}']