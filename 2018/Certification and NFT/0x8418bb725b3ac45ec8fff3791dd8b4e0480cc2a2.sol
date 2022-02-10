['pragma solidity 0.4.24;\n', 'pragma experimental "v0.5.0";\n', '\n', '/*\n', '\n', '    Copyright 2018 dYdX Trading Inc.\n', '\n', '    Licensed under the Apache License, Version 2.0 (the "License");\n', '    you may not use this file except in compliance with the License.\n', '    You may obtain a copy of the License at\n', '\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', '\n', '    Unless required by applicable law or agreed to in writing, software\n', '    distributed under the License is distributed on an "AS IS" BASIS,\n', '    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '    See the License for the specific language governing permissions and\n', '    limitations under the License.\n', '\n', '*/\n', '\n', '// File: canonical-weth/contracts/WETH9.sol\n', '\n', 'contract WETH9 {\n', '    string public name     = "Wrapped Ether";\n', '    string public symbol   = "WETH";\n', '    uint8  public decimals = 18;\n', '\n', '    event  Approval(address indexed src, address indexed guy, uint wad);\n', '    event  Transfer(address indexed src, address indexed dst, uint wad);\n', '    event  Deposit(address indexed dst, uint wad);\n', '    event  Withdrawal(address indexed src, uint wad);\n', '\n', '    mapping (address => uint)                       public  balanceOf;\n', '    mapping (address => mapping (address => uint))  public  allowance;\n', '\n', '    function() external payable {\n', '        deposit();\n', '    }\n', '    function deposit() public payable {\n', '        balanceOf[msg.sender] += msg.value;\n', '        emit Deposit(msg.sender, msg.value);\n', '    }\n', '    function withdraw(uint wad) public {\n', '        require(balanceOf[msg.sender] >= wad);\n', '        balanceOf[msg.sender] -= wad;\n', '        msg.sender.transfer(wad);\n', '        emit Withdrawal(msg.sender, wad);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return address(this).balance;\n', '    }\n', '\n', '    function approve(address guy, uint wad) public returns (bool) {\n', '        allowance[msg.sender][guy] = wad;\n', '        emit Approval(msg.sender, guy, wad);\n', '        return true;\n', '    }\n', '\n', '    function transfer(address dst, uint wad) public returns (bool) {\n', '        return transferFrom(msg.sender, dst, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(balanceOf[src] >= wad);\n', '\n', '        if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {\n', '            require(allowance[src][msg.sender] >= wad);\n', '            allowance[src][msg.sender] -= wad;\n', '        }\n', '\n', '        balanceOf[src] -= wad;\n', '        balanceOf[dst] += wad;\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: contracts/margin/interfaces/PayoutRecipient.sol\n', '\n', '/**\n', ' * @title PayoutRecipient\n', ' * @author dYdX\n', ' *\n', ' * Interface that smart contracts must implement in order to be the payoutRecipient in a\n', ' * closePosition transaction.\n', ' *\n', ' * NOTE: Any contract implementing this interface should also use OnlyMargin to control access\n', ' *       to these functions\n', ' */\n', 'interface PayoutRecipient {\n', '\n', '    // ============ Public Interface functions ============\n', '\n', '    /**\n', '     * Function a contract must implement in order to receive payout from being the payoutRecipient\n', '     * in a closePosition transaction. May redistribute any payout as necessary. Throws on error.\n', '     *\n', '     * @param  positionId         Unique ID of the position\n', '     * @param  closeAmount        Amount of the position that was closed\n', '     * @param  closer             Address of the account or contract that closed the position\n', '     * @param  positionOwner      Address of the owner of the position\n', '     * @param  heldToken          Address of the ERC20 heldToken\n', '     * @param  payout             Number of tokens received from the payout\n', '     * @param  totalHeldToken     Total amount of heldToken removed from vault during close\n', '     * @param  payoutInHeldToken  True if payout is in heldToken, false if in owedToken\n', '     * @return                    True if approved by the receiver\n', '     */\n', '    function receiveClosePositionPayout(\n', '        bytes32 positionId,\n', '        uint256 closeAmount,\n', '        address closer,\n', '        address positionOwner,\n', '        address heldToken,\n', '        uint256 payout,\n', '        uint256 totalHeldToken,\n', '        bool    payoutInHeldToken\n', '    )\n', '        external\n', '        /* onlyMargin */\n', '        returns (bool);\n', '}\n', '\n', '// File: contracts/margin/external/payoutrecipients/WethPayoutRecipient.sol\n', '\n', '/**\n', ' * @title WethPayoutRecipient\n', ' * @author dYdX\n', ' *\n', ' * Contract that allows a closer to payout W-ETH to this contract, which will unwrap it and send it\n', ' * to the closer.\n', ' */\n', 'contract WethPayoutRecipient is\n', '    PayoutRecipient\n', '{\n', '    // ============ Constants ============\n', '\n', '    address public WETH;\n', '\n', '    // ============ Constructor ============\n', '\n', '    constructor(\n', '        address weth\n', '    )\n', '        public\n', '    {\n', '        WETH = weth;\n', '    }\n', '\n', '    // ============ Public Functions ============\n', '\n', '    /**\n', '     * Fallback function. Disallows ether to be sent to this contract without data except when\n', '     * unwrapping WETH.\n', '     */\n', '    function ()\n', '        external\n', '        payable\n', '    {\n', '        require( // coverage-disable-line\n', '            msg.sender == WETH,\n', '            "WethPayoutRecipient#fallback: Cannot recieve ETH directly unless unwrapping WETH"\n', '        );\n', '    }\n', '\n', '    /**\n', '     * Function to implement the PayoutRecipient interface.\n', '     */\n', '    function receiveClosePositionPayout(\n', '        bytes32 /* positionId */ ,\n', '        uint256 /* closeAmount */,\n', '        address closer,\n', '        address /* positionOwner */,\n', '        address /* heldToken */,\n', '        uint256 payout,\n', '        uint256 /* totalHeldToken */,\n', '        bool    /* payoutInHeldToken */\n', '    )\n', '        external\n', '        returns (bool)\n', '    {\n', '        WETH9(WETH).withdraw(payout);\n', '        closer.transfer(payout);\n', '\n', '        return true;\n', '    }\n', '}']