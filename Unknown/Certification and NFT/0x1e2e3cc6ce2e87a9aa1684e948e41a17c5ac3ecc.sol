['// Refund contract for trust DAO #54\n', '\n', 'contract DAO {\n', '    function balanceOf(address addr) returns (uint);\n', '    function transferFrom(address from, address to, uint balance) returns (bool);\n', '    uint public totalSupply;\n', '}\n', '\n', 'contract WithdrawDAO {\n', '    DAO constant public mainDAO = DAO(0x52c5317c848ba20c7504cb2c8052abd1fde29d03);\n', '    address constant public trustee = 0xda4a4626d3e16e094de3225a751aab7128e96526;\n', '\n', '    function withdraw(){\n', '        uint balance = mainDAO.balanceOf(msg.sender);\n', '\n', '        if (!mainDAO.transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))\n', '            throw;\n', '    }\n', '\n', '    function trusteeWithdraw() {\n', '        trustee.send((this.balance + mainDAO.balanceOf(this)) - mainDAO.totalSupply());\n', '    }\n', '}']