['pragma solidity 0.4.24;\n', '\n', 'interface ERC20Token {\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '}\n', '\n', 'contract Timelock {\n', '    ERC20Token public token;\n', '    address public beneficiary;\n', '    uint256 public releaseTime;\n', '\n', '    event TokenReleased(address beneficiary, uint256 amount);\n', '\n', '    constructor(\n', '        address _token,\n', '        address _beneficiary,\n', '        uint256 _releaseTime\n', '    ) public {\n', '        require(_releaseTime > now);\n', '        require(_beneficiary != 0x0);\n', '        token = ERC20Token(_token);\n', '        beneficiary = _beneficiary;\n', '        releaseTime = _releaseTime;\n', '    }\n', '\n', '    function release() public returns(bool success) {\n', '        require(now >= releaseTime);\n', '        uint256 amount = token.balanceOf(this);\n', '        require(amount > 0);\n', '        token.transfer(beneficiary, amount);\n', '        emit TokenReleased(beneficiary, amount);\n', '        return true;\n', '    }\n', '}']