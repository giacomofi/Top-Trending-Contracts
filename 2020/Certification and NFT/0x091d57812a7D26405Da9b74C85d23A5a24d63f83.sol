['pragma solidity ^0.5.0;\n', '\n', 'import "./AufToken.sol";\n', '\n', '\n', 'contract AufStaking2 {\n', '    string public name = "Auf Staking phase 2";\n', '    address public owner;\n', '    AufToken public aufToken;\n', '\n', '    address[] public stakers;\n', '    mapping(address => uint) public stakingBalance;\n', '    mapping(address => bool) public hasStaked;\n', '    mapping(address => bool) public isStaking;\n', '\n', '    constructor(AufToken _aufToken) public {\n', '        aufToken = _aufToken;\n', '        \n', '        owner = msg.sender;\n', '    }\n', '\n', '    function stakeTokens(uint _amount) public {\n', '        // Require amount greater than 0\n', '        require(_amount > 0, "amount cannot be 0");\n', '\n', '        // Trasnfer Auf tokens to this contract for staking\n', '        aufToken.transferFrom(msg.sender, address(this), _amount);\n', '\n', '        // Update staking balance\n', '        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;\n', '\n', "        // Add user to stakers array *only* if they haven't staked already\n", '        if(!hasStaked[msg.sender]) {\n', '            stakers.push(msg.sender);\n', '        }\n', '\n', '        // Update staking status\n', '        isStaking[msg.sender] = true;\n', '        hasStaked[msg.sender] = true;\n', '    }\n', '\n', '    // Unstaking Tokens (Withdraw)\n', '    function unstakeTokens() public {\n', '        // Fetch staking balance\n', '        uint balance = stakingBalance[msg.sender];\n', '\n', '        // Require amount greater than 0\n', '        require(balance > 0, "staking balance cannot be 0");\n', '\n', '        // Transfer Auf tokens to this contract for staking\n', '        aufToken.transfer(msg.sender, balance);\n', '\n', '        // Reset staking balance\n', '        stakingBalance[msg.sender] = 0;\n', '\n', '        // Update staking status\n', '        isStaking[msg.sender] = false;\n', '    }\n', '\n', '    // Issuing Tokens\n', '    function issueTokens() public {\n', '        // Only owner can call this function\n', '        require(msg.sender == owner, "caller must be the owner");\n', '\n', '        // Issue tokens to all stakers\n', '        for (uint i=0; i<stakers.length; i++) {\n', '            address recipient = stakers[i];\n', '            uint balance = stakingBalance[recipient];\n', '            if(balance > 0) {\n', '                aufToken.transfer(recipient, balance * 10 / 100);\n', '            }\n', '        }\n', '    }\n', '}\n']
['pragma solidity ^0.5.0;\n', '\n', 'contract AufToken {\n', '    string  public name = "AmongUs.Finance";\n', '    string  public symbol = "AUF";\n', '    uint256 public totalSupply = 10000000000000000000000; // 10000 tokens\n', '    uint8   public decimals = 18;\n', '\n', '    event Transfer(\n', '        address indexed _from,\n', '        address indexed _to,\n', '        uint256 _value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _value\n', '    );\n', '\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    constructor() public {\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= balanceOf[_from]);\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}\n']