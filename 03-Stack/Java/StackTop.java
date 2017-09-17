package stack;

public abstract class StackTop {
	public abstract boolean isEmpty();
	public abstract Integer size();
	public abstract Object content() throws Exception;
	public abstract StackTop previous() throws Exception;
}
