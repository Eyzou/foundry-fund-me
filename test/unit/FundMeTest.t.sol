// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    //prank or makeAddr - to fake an address
    address  USER = makeAddr("Elo");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_VALUE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_VALUE);
    }

    function testMinimumDollarsIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), address(msg.sender));
    }

    function testPriceFeedVersion() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailWithoutEnoughEth() public {
        vm.expectRevert(); // the next line should revert!
        fundMe.fund(); //passed because it reverted ! as cannot fund with 0 Eth
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);// next tx send by user
        fundMe.fund{value:SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value : SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);// the next line should revert!
        fundMe.withdraw(); //passed because it reverted ! as only owner can withdraw
    }

    function testWithDrawWithASingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //Act
        //uint256 gasStart= gasleft(); // built in function in solidity -1000
        //vm.txGasPrice(GAS_PRICE); // we can see txGasPrice
        vm.prank(fundMe.getOwner()); //
        fundMe.withdraw(); // spend gas here  -200
        //uint256 gasEnd = gasleft(); // 800
        //uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        //console.log(gasUsed);

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10; // 160 to use addresses
        uint160 startingFunderIndex = 1; // sometimes the 0 address revert
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i),SEND_VALUE); //  prank and deal at the same time
            fundMe.fund{value:SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner()); // we can see startPrank
        fundMe.withdraw(); // should spend gas here ? on Anvil gas price is 0
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(startingOwnerBalance + startingFundMeBalance == fundMe.getOwner().balance);
    }

 function testCheaperWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10; // 160 to use addresses
        uint160 startingFunderIndex = 1; // sometimes the 0 address revert
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i),SEND_VALUE); //  prank and deal at the same time
            fundMe.fund{value:SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner()); // we can see startPrank
        fundMe.cheaperWithdraw(); // should spend gas here ? on Anvil gas price is 0
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(startingOwnerBalance + startingFundMeBalance == fundMe.getOwner().balance);
    }
    // but it should be lower as we used gas to tx?
}


// Using CHISEL To debug
// msg.sender is the address of the account that is calling the function.
// address(this) is the address of the contract that is currently being executed( who is created the Fund Me)
