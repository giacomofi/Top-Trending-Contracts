['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-22\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract AlkemiWETH {\n', '    string public name     = "Wrapped Ether";\n', '    string public symbol   = "WETH";\n', '    uint8  public decimals = 18;\n', '\n', '    event  Approval(address indexed src, address indexed guy, uint wad);\n', '    event  Transfer(address indexed src, address indexed dst, uint wad);\n', '    event  Deposit(address indexed dst, uint wad);\n', '    event  Withdrawal(address indexed src, uint wad);\n', '\n', '    mapping (address => uint)                       public  balanceOf;\n', '    mapping (address => mapping (address => uint))  public  allowance;\n', '\n', '    function() public payable {\n', '        deposit();\n', '    }\n', '    function deposit() public payable {\n', '        balanceOf[msg.sender] += msg.value;\n', '        emit Deposit(msg.sender, msg.value);\n', '    }\n', '    function withdraw(address user, uint wad) public {\n', '        require(balanceOf[msg.sender] >= wad);\n', '        balanceOf[msg.sender] -= wad;\n', '        user.transfer(wad);\n', '        emit Withdrawal(msg.sender, wad);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function approve(address guy, uint wad) public returns (bool) {\n', '        allowance[msg.sender][guy] = wad;\n', '        emit Approval(msg.sender, guy, wad);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address dst, uint wad) public returns (bool) {\n', '        return transferFrom(msg.sender, dst, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(balanceOf[src] >= wad);\n', '\n', '        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {\n', '            require(allowance[src][msg.sender] >= wad);\n', '            allowance[src][msg.sender] -= wad;\n', '        }\n', '\n', '        balanceOf[src] -= wad;\n', '        balanceOf[dst] += wad;\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '}']