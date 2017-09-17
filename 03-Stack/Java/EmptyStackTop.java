package stack;

public class EmptyStackTop implements StackTop {

	public boolean isEmpty() {
		return Boolean.TRUE;
	}

	public Integer size() {
		return 0;
	}

	public Object content()  {
		throw new RuntimeException(Stack.STACK_EMPTY_DESCRIPTION);
	}

	public StackTop previous() {
		throw new RuntimeException(Stack.STACK_EMPTY_DESCRIPTION);
	}
}
