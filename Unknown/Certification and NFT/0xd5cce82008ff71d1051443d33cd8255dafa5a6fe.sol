['/**\n', ' * Copyright (C) Virtue Fintech FZ-LLC, Dubai\n', ' * All rights reserved.\n', ' * Author: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="b4d9dcddf4c2ddc6c0c1d19ad2dddad5dad7d1">[email&#160;protected]</a> \n', ' *\n', ' * MIT License\n', ' *\n', ' * Permission is hereby granted, free of charge, to any person obtaining a copy \n', ' * of this software and associated documentation files (the ""Software""), to \n', ' * deal in the Software without restriction, including without limitation the \n', ' * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or \n', ' * sell copies of the Software, and to permit persons to whom the Software is \n', ' * furnished to do so, subject to the following conditions: \n', ' *  The above copyright notice and this permission notice shall be included in \n', ' *  all copies or substantial portions of the Software.\n', ' *\n', ' * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR \n', ' * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, \n', ' * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE \n', ' * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER \n', ' * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, \n', ' * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN \n', ' * THE SOFTWARE.\n', ' *\n', ' */\n', 'pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * Guards is a handful of modifiers to be used throughout this project\n', ' */\n', 'contract Guarded {\n', '\n', '    modifier isValidAmount(uint256 _amount) { \n', '        require(_amount > 0); \n', '        _; \n', '    }\n', '\n', '    // ensure address not null, and not this contract address\n', '    modifier isValidAddress(address _address) {\n', '        require(_address != 0x0 && _address != address(this));\n', '        _;\n', '    }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    /** \n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner. \n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to. \n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract FaradTokenSwap is Guarded, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) contributions;          // contributions from public\n', '    uint256 contribCount = 0;\n', '\n', '    string public version = &#39;0.1.2&#39;;\n', '\n', '    uint256 public startBlock = 4280263;                // 16th September 2017, 00:00:00 - 1505520000\n', '    uint256 public endBlock = 4334263;                  // 30th September 2017, 23:59:59 - 1506815999\n', '\n', '    uint256 public totalEtherCap = 1184834 ether;       // Total raised for ICO, at USD 211/ether\n', '    uint256 public weiRaised = 0;                       // wei raised in this ICO\n', '    uint256 public minContrib = 0.05 ether;             // min contribution accepted\n', '\n', '    address public wallet = 0x5dc638EAa4f823612DC278d0f039588bb10112a2;\n', '\n', '    event Contribution(address indexed _contributor, uint256 _amount);\n', '\n', '    function FaradTokenSwap() {\n', '    }\n', '\n', '    // function to start the Token Sale\n', '    /// start the token sale at `_starBlock`\n', '    function setStartBlock(uint256 _startBlock) onlyOwner public {\n', '        startBlock = _startBlock;\n', '    }\n', '\n', '    // function to stop the Token Swap \n', '    /// stop the token swap at `_endBlock`\n', '    function setEndBlock(uint256 _endBlock) onlyOwner public {\n', '        endBlock = _endBlock;\n', '    }\n', '\n', '    // this function is to add the previous token sale balance.\n', '    /// set the accumulated balance of `_weiRaised`\n', '    function setWeiRaised(uint256 _weiRaised) onlyOwner public {\n', '        weiRaised = weiRaised.add(_weiRaised);\n', '    }\n', '\n', '    // set the wallet address\n', '    /// set the wallet at `_wallet`\n', '    function setWallet(address _wallet) onlyOwner public {\n', '        wallet = _wallet;\n', '    }\n', '\n', '    /// set the minimum contribution to `_minContrib`\n', '    function setMinContribution(uint256 _minContrib) onlyOwner public {\n', '        minContrib = _minContrib;\n', '    }\n', '\n', '    // @return true if token swap event has ended\n', '    function hasEnded() public constant returns (bool) {\n', '        return block.number >= endBlock;\n', '    }\n', '\n', '    // @return true if the token swap contract is active.\n', '    function isActive() public constant returns (bool) {\n', '        return block.number >= startBlock && block.number <= endBlock;\n', '    }\n', '\n', '    function () payable {\n', '        processContributions(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '     * Okay, we changed the process flow a bit where the actual FRD to ETH\n', '     * mapping shall be calculated, and pushed to the contract once the\n', '     * crowdsale is over.\n', '     *\n', '     * Then, the user can pull the tokens to their wallet.\n', '     *\n', '     */\n', '    function processContributions(address _contributor, uint256 _weiAmount) payable {\n', '        require(validPurchase());\n', '\n', '        uint256 updatedWeiRaised = weiRaised.add(_weiAmount);\n', '\n', '        // update state\n', '        weiRaised = updatedWeiRaised;\n', '\n', '        // notify event for this contribution\n', '        contributions[_contributor] = contributions[_contributor].add(_weiAmount);\n', '        contribCount += 1;\n', '        Contribution(_contributor, _weiAmount);\n', '\n', '        // forware the funds\n', '        forwardFunds();\n', '    }\n', '\n', '    // @return true if the transaction can buy tokens\n', '    function validPurchase() internal constant returns (bool) {\n', '        uint256 current = block.number;\n', '\n', '        bool withinPeriod = current >= startBlock && current <= endBlock;\n', '        bool minPurchase = msg.value >= minContrib;\n', '\n', '        // add total wei raised\n', '        uint256 totalWeiRaised = weiRaised.add(msg.value);\n', '        bool withinCap = totalWeiRaised <= totalEtherCap;\n', '\n', '        // check all 3 conditions met\n', '        return withinPeriod && minPurchase && withinCap;\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    // override to create custom fund forwarding mechanisms\n', '    function forwardFunds() internal {\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '}']
['/**\n', ' * Copyright (C) Virtue Fintech FZ-LLC, Dubai\n', ' * All rights reserved.\n', ' * Author: mhi@virtue.finance \n', ' *\n', ' * MIT License\n', ' *\n', ' * Permission is hereby granted, free of charge, to any person obtaining a copy \n', ' * of this software and associated documentation files (the ""Software""), to \n', ' * deal in the Software without restriction, including without limitation the \n', ' * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or \n', ' * sell copies of the Software, and to permit persons to whom the Software is \n', ' * furnished to do so, subject to the following conditions: \n', ' *  The above copyright notice and this permission notice shall be included in \n', ' *  all copies or substantial portions of the Software.\n', ' *\n', ' * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR \n', ' * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, \n', ' * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE \n', ' * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER \n', ' * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, \n', ' * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN \n', ' * THE SOFTWARE.\n', ' *\n', ' */\n', 'pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * Guards is a handful of modifiers to be used throughout this project\n', ' */\n', 'contract Guarded {\n', '\n', '    modifier isValidAmount(uint256 _amount) { \n', '        require(_amount > 0); \n', '        _; \n', '    }\n', '\n', '    // ensure address not null, and not this contract address\n', '    modifier isValidAddress(address _address) {\n', '        require(_address != 0x0 && _address != address(this));\n', '        _;\n', '    }\n', '\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    /** \n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner. \n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to. \n', '     */\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract FaradTokenSwap is Guarded, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) contributions;          // contributions from public\n', '    uint256 contribCount = 0;\n', '\n', "    string public version = '0.1.2';\n", '\n', '    uint256 public startBlock = 4280263;                // 16th September 2017, 00:00:00 - 1505520000\n', '    uint256 public endBlock = 4334263;                  // 30th September 2017, 23:59:59 - 1506815999\n', '\n', '    uint256 public totalEtherCap = 1184834 ether;       // Total raised for ICO, at USD 211/ether\n', '    uint256 public weiRaised = 0;                       // wei raised in this ICO\n', '    uint256 public minContrib = 0.05 ether;             // min contribution accepted\n', '\n', '    address public wallet = 0x5dc638EAa4f823612DC278d0f039588bb10112a2;\n', '\n', '    event Contribution(address indexed _contributor, uint256 _amount);\n', '\n', '    function FaradTokenSwap() {\n', '    }\n', '\n', '    // function to start the Token Sale\n', '    /// start the token sale at `_starBlock`\n', '    function setStartBlock(uint256 _startBlock) onlyOwner public {\n', '        startBlock = _startBlock;\n', '    }\n', '\n', '    // function to stop the Token Swap \n', '    /// stop the token swap at `_endBlock`\n', '    function setEndBlock(uint256 _endBlock) onlyOwner public {\n', '        endBlock = _endBlock;\n', '    }\n', '\n', '    // this function is to add the previous token sale balance.\n', '    /// set the accumulated balance of `_weiRaised`\n', '    function setWeiRaised(uint256 _weiRaised) onlyOwner public {\n', '        weiRaised = weiRaised.add(_weiRaised);\n', '    }\n', '\n', '    // set the wallet address\n', '    /// set the wallet at `_wallet`\n', '    function setWallet(address _wallet) onlyOwner public {\n', '        wallet = _wallet;\n', '    }\n', '\n', '    /// set the minimum contribution to `_minContrib`\n', '    function setMinContribution(uint256 _minContrib) onlyOwner public {\n', '        minContrib = _minContrib;\n', '    }\n', '\n', '    // @return true if token swap event has ended\n', '    function hasEnded() public constant returns (bool) {\n', '        return block.number >= endBlock;\n', '    }\n', '\n', '    // @return true if the token swap contract is active.\n', '    function isActive() public constant returns (bool) {\n', '        return block.number >= startBlock && block.number <= endBlock;\n', '    }\n', '\n', '    function () payable {\n', '        processContributions(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '     * Okay, we changed the process flow a bit where the actual FRD to ETH\n', '     * mapping shall be calculated, and pushed to the contract once the\n', '     * crowdsale is over.\n', '     *\n', '     * Then, the user can pull the tokens to their wallet.\n', '     *\n', '     */\n', '    function processContributions(address _contributor, uint256 _weiAmount) payable {\n', '        require(validPurchase());\n', '\n', '        uint256 updatedWeiRaised = weiRaised.add(_weiAmount);\n', '\n', '        // update state\n', '        weiRaised = updatedWeiRaised;\n', '\n', '        // notify event for this contribution\n', '        contributions[_contributor] = contributions[_contributor].add(_weiAmount);\n', '        contribCount += 1;\n', '        Contribution(_contributor, _weiAmount);\n', '\n', '        // forware the funds\n', '        forwardFunds();\n', '    }\n', '\n', '    // @return true if the transaction can buy tokens\n', '    function validPurchase() internal constant returns (bool) {\n', '        uint256 current = block.number;\n', '\n', '        bool withinPeriod = current >= startBlock && current <= endBlock;\n', '        bool minPurchase = msg.value >= minContrib;\n', '\n', '        // add total wei raised\n', '        uint256 totalWeiRaised = weiRaised.add(msg.value);\n', '        bool withinCap = totalWeiRaised <= totalEtherCap;\n', '\n', '        // check all 3 conditions met\n', '        return withinPeriod && minPurchase && withinCap;\n', '    }\n', '\n', '    // send ether to the fund collection wallet\n', '    // override to create custom fund forwarding mechanisms\n', '    function forwardFunds() internal {\n', '        wallet.transfer(msg.value);\n', '    }\n', '\n', '}']
