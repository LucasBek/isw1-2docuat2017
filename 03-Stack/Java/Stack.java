/*
 * Developed by 10Pines SRL
 * License: 
 * This work is licensed under the 
 * Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ 
 * or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, 
 * California, 94041, USA.
 *  
 */
package stack;

public class Stack {
	private StackTop top;
	public Stack () {
		top = new EmptyStackTop();
	}
	
	public static final String STACK_EMPTY_DESCRIPTION = "Stack is Empty";

	public void push (Object anObject)
	{
		top = new FilledStackTop(top, anObject);
	}
	
	public Object pop()
	{
		Object previous = this.top();
		top = top.previous();
		return previous;
	}
	
	public Object top()
	{
		return top.content();
	}

	public Boolean isEmpty()
	{
		return top.isEmpty();
	}

	public Integer size()
	{
		return top.size();
	}
}
