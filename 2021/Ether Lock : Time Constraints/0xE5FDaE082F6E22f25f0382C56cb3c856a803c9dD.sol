['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-02\n', '*/\n', '\n', '// Verified using https://dapp.tools\n', '\n', '// hevm: flattened sources of src/lender/reserve.sol\n', '// SPDX-License-Identifier: AGPL-3.0-only\n', 'pragma solidity >=0.5.15 >=0.6.12;\n', '\n', '////// lib/tinlake-auth/src/auth.sol\n', '// Copyright (C) Centrifuge 2020, based on MakerDAO dss https://github.com/makerdao/dss\n', '/* pragma solidity >=0.5.15; */\n', '\n', 'contract Auth {\n', '    mapping (address => uint256) public wards;\n', '    \n', '    event Rely(address indexed usr);\n', '    event Deny(address indexed usr);\n', '\n', '    function rely(address usr) external auth {\n', '        wards[usr] = 1;\n', '        emit Rely(usr);\n', '    }\n', '    function deny(address usr) external auth {\n', '        wards[usr] = 0;\n', '        emit Deny(usr);\n', '    }\n', '\n', '    modifier auth {\n', '        require(wards[msg.sender] == 1, "not-authorized");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '////// lib/tinlake-math/src/math.sol\n', '// Copyright (C) 2018 Rain <[email\xa0protected]>\n', '/* pragma solidity >=0.5.15; */\n', '\n', 'contract Math {\n', '    uint256 constant ONE = 10 ** 27;\n', '\n', '    function safeAdd(uint x, uint y) public pure returns (uint z) {\n', '        require((z = x + y) >= x, "safe-add-failed");\n', '    }\n', '\n', '    function safeSub(uint x, uint y) public pure returns (uint z) {\n', '        require((z = x - y) <= x, "safe-sub-failed");\n', '    }\n', '\n', '    function safeMul(uint x, uint y) public pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x, "safe-mul-failed");\n', '    }\n', '\n', '    function safeDiv(uint x, uint y) public pure returns (uint z) {\n', '        z = x / y;\n', '    }\n', '\n', '    function rmul(uint x, uint y) public pure returns (uint z) {\n', '        z = safeMul(x, y) / ONE;\n', '    }\n', '\n', '    function rdiv(uint x, uint y) public pure returns (uint z) {\n', '        require(y > 0, "division by zero");\n', '        z = safeAdd(safeMul(x, ONE), y / 2) / y;\n', '    }\n', '\n', '    function rdivup(uint x, uint y) internal pure returns (uint z) {\n', '        require(y > 0, "division by zero");\n', '        // always rounds up\n', '        z = safeAdd(safeMul(x, ONE), safeSub(y, 1)) / y;\n', '    }\n', '\n', '\n', '}\n', '\n', '////// src/lender/reserve.sol\n', '/* pragma solidity >=0.6.12; */\n', '\n', '/* import "tinlake-math/math.sol"; */\n', '/* import "tinlake-auth/auth.sol"; */\n', '\n', 'interface ERC20Like_2 {\n', '    function balanceOf(address) external view returns (uint256);\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '    function mint(address, uint256) external;\n', '    function burn(address, uint256) external;\n', '    function totalSupply() external view returns (uint256);\n', '    function approve(address, uint) external;\n', '}\n', '\n', 'interface ShelfLike_3 {\n', '    function balanceRequest() external returns (bool requestWant, uint256 amount);\n', '}\n', '\n', 'interface AssessorLike_4 {\n', '    function repaymentUpdate(uint amount) external;\n', '    function borrowUpdate(uint amount) external;\n', '}\n', '\n', 'interface LendingAdapter_2 {\n', '    function remainingCredit() external view returns (uint);\n', '    function draw(uint amount) external;\n', '    function wipe(uint amount) external;\n', '    function debt() external returns(uint);\n', '    function activated() external view returns(bool);\n', '}\n', '\n', '// The reserve keeps track of the currency and the bookkeeping\n', '// of the total balance\n', 'contract Reserve is Math, Auth {\n', '    ERC20Like_2 public currency;\n', '    ShelfLike_3 public shelf;\n', '    AssessorLike_4 public assessor;\n', '\n', '    // additional currency from lending adapters\n', '    // for deactivating set to address(0)\n', '    LendingAdapter_2 public lending;\n', '\n', '    // currency available for borrowing new loans\n', '    uint256 public currencyAvailable;\n', '\n', '    // address or contract which holds the currency\n', '    // by default it is address(this)\n', '    address pot;\n', '\n', '    // total currency in the reserve\n', '    uint public balance_;\n', '\n', '    constructor(address currency_) {\n', '        wards[msg.sender] = 1;\n', '        currency = ERC20Like_2(currency_);\n', '        pot = address(this);\n', '        currency.approve(pot, type(uint256).max);\n', '    }\n', '\n', '    function file(bytes32 what, uint amount) public auth {\n', '        if (what == "currencyAvailable") {\n', '            currencyAvailable = amount;\n', '        } else revert();\n', '    }\n', '\n', '    function depend(bytes32 contractName, address addr) public auth {\n', '        if (contractName == "shelf") {\n', '            shelf = ShelfLike_3(addr);\n', '        } else if (contractName == "currency") {\n', '            currency = ERC20Like_2(addr);\n', '            if (pot == address(this)) {\n', '                currency.approve(pot, type(uint256).max);\n', '            }\n', '        } else if (contractName == "assessor") {\n', '            assessor = AssessorLike_4(addr);\n', '        } else if (contractName == "pot") {\n', '            pot = addr;\n', '        } else if (contractName == "lending") {\n', '            lending = LendingAdapter_2(addr);\n', '        } else revert();\n', '    }\n', '\n', '    // returns the amount of currency currently in the reserve\n', '    function totalBalance() public view returns (uint) {\n', '        return balance_;\n', '    }\n', '\n', '    // return the amount of currency and the available currency from the lending adapter\n', '    function totalBalanceAvailable() public view returns (uint) {\n', '        if(address(lending) == address(0)) {\n', '            return balance_;\n', '        }\n', '\n', '        return safeAdd(balance_, lending.remainingCredit());\n', '    }\n', '\n', '    // deposits currency in the the reserve\n', '    function deposit(uint currencyAmount) public auth {\n', '        if(currencyAmount == 0) return;\n', '        _deposit(msg.sender, currencyAmount);\n', '    }\n', '\n', '    // hard deposit guarantees that the currency stays in the reserve\n', '    function hardDeposit(uint currencyAmount) public auth {\n', '        _depositAction(msg.sender, currencyAmount);\n', '    }\n', '\n', '    function _depositAction(address usr, uint currencyAmount) internal {\n', '        require(currency.transferFrom(usr, pot, currencyAmount), "reserve-deposit-failed");\n', '        balance_ = safeAdd(balance_, currencyAmount);\n', '    }\n', '\n', '    function _deposit(address usr, uint currencyAmount) internal {\n', '        _depositAction(usr, currencyAmount);\n', '        if(address(lending) != address(0) && lending.debt() > 0 && lending.activated()) {\n', '            uint wipeAmount = lending.debt();\n', '            uint available = currency.balanceOf(pot);\n', '            if(available < wipeAmount) {\n', '                wipeAmount = available;\n', '            }\n', '            lending.wipe(wipeAmount);\n', '        }\n', '    }\n', '\n', '    // remove currency from the reserve\n', '    function payout(uint currencyAmount) public auth {\n', '        if(currencyAmount == 0) return;\n', '        _payout(msg.sender, currencyAmount);\n', '    }\n', '\n', '    function _payoutAction(address usr, uint currencyAmount) internal {\n', '        require(currency.transferFrom(pot, usr, currencyAmount), "reserve-payout-failed");\n', '        balance_ = safeSub(balance_, currencyAmount);\n', '    }\n', '\n', '    // hard payout guarantees that the currency stays in the reserve\n', '    function hardPayout(uint currencyAmount) public auth {\n', '        _payoutAction(msg.sender, currencyAmount);\n', '    }\n', '\n', '    function _payout(address usr, uint currencyAmount)  internal {\n', '        uint reserveBalance = currency.balanceOf(pot);\n', '        if (currencyAmount > reserveBalance && address(lending) != address(0) && lending.activated()) {\n', '            uint drawAmount = safeSub(currencyAmount, reserveBalance);\n', '            uint left = lending.remainingCredit();\n', '            if(drawAmount > left) {\n', '                drawAmount = left;\n', '            }\n', '\n', '            lending.draw(drawAmount);\n', '        }\n', '\n', '        _payoutAction(usr, currencyAmount);\n', '    }\n', '\n', '    // balance handles currency requests from the borrower side\n', '    // currency is moved between shelf and reserve if needed\n', '    function balance() public {\n', '        (bool requestWant, uint256 currencyAmount) = shelf.balanceRequest();\n', '        if(currencyAmount == 0) {\n', '            return;\n', '        }\n', '        if (requestWant) {\n', '            require(\n', '                currencyAvailable  >= currencyAmount,\n', '                "not-enough-currency-reserve"\n', '            );\n', '\n', '            currencyAvailable = safeSub(currencyAvailable, currencyAmount);\n', '            _payout(address(shelf), currencyAmount);\n', '            assessor.borrowUpdate(currencyAmount);\n', '            return;\n', '        }\n', '        _deposit(address(shelf), currencyAmount);\n', '        assessor.repaymentUpdate(currencyAmount);\n', '    }\n', '}']